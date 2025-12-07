<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorePropertyRequest;
use App\Http\Requests\UpdatePropertyRequest;
use Auth;
use App\Models\Property;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\Request;
use App\Http\Requests\storeproperty;

class PropertyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function my_properties()
    {
        $user = auth()->user();
        $properties = $user->property()->with('image')->get();
        return response()->json(
            [
                'data' => $properties,
                'message' => 'here all your properties',
                'status' => 200,
            ]
        );
    }

    public function all_properties()
    {
        $properties = Property::with('image')->get();
        return response()->json(
            [
                'data' => $properties,
                'message' => 'here all properties',
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
        
        $property->image()->createMany(
            collect($validated['images'])->map(fn($image) => ['image' => $image])->toArray()
        );

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
        return response()->json([
            'data' => $property,
            'images' => $property->images()->get(),
            'message' => 'Property returned successfully',
        ], 200);
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
        if (!empty($validated['images'])) {
            $property->images()->createMany(
                collect($validated['images'])->map(fn($image) => ['image' => $image])->toArray()
            );
        }
        if (!empty($validated['erase'])) {
            $property->images()->whereIn('id', $validated['erase'])->delete();
        }
        
        $property->refresh();
        return response()->json([
            'property' => $property,
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
