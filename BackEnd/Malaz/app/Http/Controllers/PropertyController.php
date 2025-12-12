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
            ->with([
                'images' => function ($q) {
                    $q->orderBy('id', 'asc')->limit(1);
                }
            ])
            ->orderBy('id', 'desc')
            ->cursorPaginate($perPage)
            ->through(function ($property) {
                $property->first_image = $property->images->first()
                    ? url('/images/' . $property->images->first()->id)
                    : null;
                unset($property->images);
                return $property;
            });

        return response()->json(
            [
                'data' => $properties->items(),
                'message' => 'here all your properties',
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

        $properties = Property::where('status', 'approved')->with('images')
            ->orderBy('id', 'desc')
            ->cursorPaginate($perPage)
            ->through(function ($property) {
                $property->first_image = $property->images->first()
                    ? url('/images/' . $property->images->first()->id)
                    : null;
                unset($property->images);
                return $property;
            });

        return response()->json(
            [
                'data' => $properties->items(),
                'message' => 'here all properties',
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
            collect($validated)->except('images')->toArray()
        );

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $file) {
                $imageData = file_get_contents($file->getRealPath());
                $property->images()->create([
                    'image' => $imageData,
                    'mime_type' => $file->getMimeType(),

                ]);
            }
        }
        return response()->json([
            'data' => $property,
            'message' => 'Property created successfully',
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Property $property)
    {

        if ($property->status !== 'approved') {
            return response()->json([
                'message' => 'Property not approved',
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

        return response()->json([
            'data' => $property,
            'rate' => $rate,
            'images' => $images,
            'isFav' => $isFav,
            'message' => 'Property returned successfully',
        ], 200);
    }

    public function favonwho($propertyId)
    {

        $property = Property::find($propertyId);

        if (!$property) {
            return response()->json([
                'message' => 'Property not found',
                'status' => 404,
            ]);
        }

        $users = $property->favoritedBy;

        return response()->json([
            'users' => $users,
            'message' => 'all of those love this property',
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
        $property->update($validated);

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $file) {
                $property->images()->create([
                    'image' => file_get_contents($file->getRealPath()),
                    'mime_type' => $file->getMimeType(),
                ]);
            }
        }

        if (!empty($validated['erase'])) {
            $property->images()->whereIn('id', $validated['erase'])->delete();
        }

        $property->refresh();
        return response()->json([
            'property' => $property->load('images'),
            'message' => 'update completed',
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
            'message' => 'Property deleted',
            'status' => 200,
        ]);
    }
}
