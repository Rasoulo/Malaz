<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\Property;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = auth()->user();
        $reviews = $user->reviews()->with('property')->get();
        return response()->json([
            'reviews' => $reviews,
            'message' => __('validation.review.all_user_reviews'),
            'status' => 200,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request, $propertyId)
    {
        $request->validate([
            'rating' => 'integer|min:-1|max:5',
            'body' => 'string|max:255',
        ]);

        if (!($request->filled('rating') && $request->rating != -1) && !$request->filled('body')) {
            return response()->json([
                'message' => __('validation.review.require_rating_or_body'),
                'status' => 400,
            ]);
        }
        $user = auth()->user();
        $exists = Booking::where('user_id', $user->id)
            ->where('property_id', $propertyId)
            ->where('status', 'completed')
            ->exists();

        $alreadyReviewed = Review::where('user_id', $user->id)
            ->where('property_id', $propertyId)
            ->exists();

        if ($alreadyReviewed) {
            return response()->json([
                'message' => __('validation.review.already_reviewed'),
                'status' => 400,
            ]);
        }

        if ($exists) {
            $review = Review::create([
                'user_id' => $user->id,
                'property_id' => $propertyId,
                'rating' => max($request->rating, 0),
                'body' => $request->body,
            ]);

            if ($request->rating != -1) {
                $property = $review->property;
                $property->rating += $request->rating;
                $property->number_of_reviews += 1;
                $property->save();
            }
            return response()->json([
                'review' => $review,
                'message' => __('validation.review.published'),
                'status' => 201,
            ]);
        }

        return response()->json([
            'message' => __('validation.review.must_reserve_before'),
            'status' => 400,
        ]);
    }

    /*
        $alreadyReviewed = Review::where('user_id', $user->id)
    ->where('property_id', $propertyId)
    ->exists();

if ($alreadyReviewed) {
    return response()->json([
        'message' => 'You have already reviewed this property.',
        'status' => 400,
    ]);
}
    */

    /**
     * Display the specified resource.
     */
    public function show(Review $review)
    {
        return response()->json([
            'review' => $review->load('property', 'user'),
            'status' => 200,
        ]);
    }

    public function propertyReviews(Request $request, $propertyId)
    {
        $perPage = (int) $request->input('per_page', 20);

        $reviews = Review::where('property_id', $propertyId)
            ->whereHas('property', fn($q) => $q->where('status', 'approved'))
            ->whereNotNull('body')
            ->orderBy('id', 'desc')
            ->cursorPaginate($perPage)
            ->through(function ($review) {
                return [
                    'id' => $review->id,
                    'user_id' => $review->user_id,
                    'rating' => $review->rating,
                    'body' => $review->body,
                    'created_at' => $review->created_at,
                ];
            });

        return response()->json([
            'data' => $reviews->items(),
            'message' => __('validation.review.property_reviews'),
            'meta' => [
                'next_cursor' => $reviews->nextCursor()?->encode(),
                'prev_cursor' => $reviews->previousCursor()?->encode(),
                'per_page' => $reviews->perPage(),
            ],
            'status' => 200,
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Review $review)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Review $review)
    {
        if ($review->user_id !== auth()->id()) {
            return response()->json(['message' => __('validation.review.unauthorized')], 403);
        }

        $request->validate([
            'rating' => 'sometimes|integer|min:-1|max:5',
            'body' => 'sometimes|string|max:255',
        ]);

        if ($request->filled('rating') && $request->rating != -1) {
            $property = $review->property;
            if ($review->rating == 0)
                $property->number_of_reviews += 1;
            $property->rating += $request->rating - $review->rating;
            $property->save();
        }

        $review->update($request->only(['rating', 'body']));

        return response()->json([
            'review' => $review,
            'message' => __('validation.review.updated'),
            'status' => 200,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Review $review)
    {
        if ($review->user_id !== auth()->id()) {
            return response()->json(['message' => __('validation.review.unauthorized')], 403);
        }

        $property = $review->property;
        $property->rating -= $review->rating;
        $property->number_of_reviews = max(0, $property->number_of_reviews - 1);
        $property->save();

        $review->delete();
        return response()->json([
            'message' => __('validation.review.deleted'),
            'status' => 200,
        ]);
    }
}
