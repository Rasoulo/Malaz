<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorePropertyRequest;
use App\Http\Requests\UpdatePropertyRequest;
use App\Models\Property;
use Illuminate\Http\Request;

class PropertyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function my_properties(Request $request)
    {
        $user = auth()->user();
        $perPage = (int) $request->input('per_page', 20);

        $properties = $user->property()
            ->where('status', 'approved')
            ->orderBy('id', 'desc')
            ->cursorPaginate($perPage);

        return response()->json(
            [
                'data' => $properties->items(),
                'message' => __('validation.property.my_list'),
                'meta' => [
                    'next_cursor' => $properties->nextCursor()?->encode(),
                    'prev_cursor' => $properties->previousCursor()?->encode(),
                    'per_page' => $properties->perPage(),
                ],
                'status' => 200,
            ]
        );
    }

    public function all_properties(Request $request)
    {

        $perPage = (int) $request->input('per_page', 20);

        $properties = Property::where('status', 'approved')
            ->orderBy('id', 'desc')
            ->cursorPaginate($perPage);

        return response()->json(
            [
                'data' => $properties->items(),
                'message' => __('validation.property.all_list'),
                'meta' => [
                    'next_cursor' => $properties->nextCursor()?->encode(),
                    'prev_cursor' => $properties->previousCursor()?->encode(),
                    'per_page' => $properties->perPage(),
                ],
                'status' => 200,
            ]
        );
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {

    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StorePropertyRequest $request)
    {
        $user = auth()->user();
        $validated = $request->validated();
        $validated['owner_id'] = $user->id;
        $property = Property::create(
            collect($validated)->except(['images', 'main_pic'])->toArray()
        );

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $file) {
                $imageData = base64_encode(file_get_contents($file->getRealPath()));
                $property->images()->create([
                    'image' => $imageData,
                    'mime_type' => $file->getMimeType(),
                ]);
            }
        }

        if ($request->hasFile('main_pic')) {
            $file = $request->file('main_pic');
            $imageData = base64_encode(file_get_contents($file->getRealPath()));
            $property->update([
                'main_image' => $imageData,
                'mime_type' => $file->getMimeType(),
            ]);
            // $property->main_image = $imageData;
            // $property->mime_type = $file->getMimeType();
            // $property->save();
            // return 1;
        }

        // $property->status = 'approved';
        $property->save();

        return response()->json([
            'data' => $property,
            'message' => __('validation.property.created'),
        ], 201);
    }

    public function showmainpic(Property $property)
    {
        $image = base64_decode($property->main_image);
        $mime_type = $property->mime_type;
        return response($image)
            ->header('Content-Type', $mime_type);
    }

    /**
     * Display the specified resource.
     */
    public function show(Property $property)
    {

        if ($property->status !== 'approved') {
            return response()->json([
                'message' => __('validation.property.not_approved'),
                'status' => 403,
            ]);
        }

        $rate = $property->number_of_reviews > 0
            ? round($property->rating / $property->number_of_reviews)
            : 0;

        $images = $property->images->map(function ($img) {
            return url('/images/' . $img->id);
        });


        $isFav = $property->favoritedBy()->where('user_id', auth()->id())->exists();
        $user = $property->user;
        return response()->json([
            'data' => $property,
            'rate' => $rate,
            'isFav' => $isFav,
            'owner' => $user,
            'message' => __('validation.property.returned'),
        ], 200);
    }

    public function favonwho($propertyId)
    {

        $property = Property::find($propertyId);

        if (!$property) {
            return response()->json([
                'message' => __('validation.property.not_found'),
                'status' => 404,
            ]);
        }

        $users = $property->favoritedBy;

        return response()->json([
            'users' => $users,
            'message' => __('validation.property.favorited_by'),
            'status' => 200,
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Property $property)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdatePropertyRequest $request, Property $property)
    {
        $this->authorize('update', $property);

        $validated = $request->validated();
        $property->update(
            collect($validated)->except(['images', 'main_pic', 'erase', 'mime_type'])->toArray()
        );

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $file) {
                $property->images()->create([
                    'image' => base64_encode(file_get_contents($file->getRealPath())),
                    'mime_type' => $file->getMimeType(),
                ]);
            }
        }

        if ($request->hasFile('main_pic')) {
            $file = $request->file('main_pic');
            $property->main_image = base64_encode(file_get_contents($file->getRealPath()));
            $property->mime_type = $file->getMimeType();
            $property->save();
        }

        if (!empty($validated['erase'])) {
            $property->images()->whereIn('id', $validated['erase'])->delete();
        }
        $property->status = 'pending';
        $property->save();
        $property->refresh();

        return response()->json([
            'property' => $property,
            'message' => __('validation.property.updated'),
            'status' => 200,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Property $property)
    {
        $this->authorize('delete', $property);
        $property->delete();
        return response()->json([
            'message' => __('validation.property.deleted'),
            'status' => 200,
        ]);
    }
}
