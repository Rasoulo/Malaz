<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorePropertyRequest;
use App\Http\Requests\UpdatePropertyRequest;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PropertyController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function my_properties(Request $request)
    {
        $user = auth()->user();
        $perPage = (int) $request->input('per_page', 20);

        $query = $user->property()
            ->with(['images', 'user'])
            ->where('status', 'approved')
            ->when($request->filled('type'), fn($q) => $q->where('type', $request->input('type')))
            ->when($request->filled('price_min'), fn($q) => $q->where('price', '>=', (int) $request->input('price_min')))
            ->when($request->filled('price_max'), fn($q) => $q->where('price', '<=', (int) $request->input('price_max')))
            ->when($request->filled('rooms_min'), fn($q) => $q->where('number_of_rooms', '>=', (int) $request->input('rooms_min')))
            ->when($request->filled('rooms_max'), fn($q) => $q->where('number_of_rooms', '<=', (int) $request->input('rooms_max')))
            ->when($request->filled('baths_min'), fn($q) => $q->where('number_of_baths', '>=', (int) $request->input('baths_min')))
            ->when($request->filled('baths_max'), fn($q) => $q->where('number_of_baths', '<=', (int) $request->input('baths_max')))
            ->when($request->filled('area_min'), fn($q) => $q->where('area', '>=', (int) $request->input('area_min')))
            ->when($request->filled('area_max'), fn($q) => $q->where('area', '<=', (int) $request->input('area_max')))
            ->when($request->filled('city'), fn($q) => $q->where('city', $request->input('city')))
            ->when($request->filled('governorate'), fn($q) => $q->where('governorate', $request->input('governorate')));

        // If sort nearest and lat/lng provided, compute distance and order by it
        if ($request->input('sort') === 'nearest' && $request->filled('lat') && $request->filled('lng')) {
            $lat = (float) $request->input('lat');
            $lng = (float) $request->input('lng');
            $haversine = "(6371 * acos(cos(radians(?)) * cos(radians(latitude+0)) * cos(radians(longitude+0) - radians(?)) + sin(radians(?)) * sin(radians(latitude+0))))";
            $query->selectRaw('properties.*,' . $haversine . ' AS distance', [$lat, $lng, $lat]);
            $query->whereNotNull('latitude')->whereNotNull('longitude');
            $query->orderBy('distance')->orderBy('id', 'desc');
        } else {
            if ($request->input('sort') === 'price_asc') {
                $query->orderBy('price', 'asc');
            } elseif ($request->input('sort') === 'price_desc') {
                $query->orderBy('price', 'desc');
            } else {
                $query->orderBy('id', 'desc');
            }
        }

        $properties = $query->cursorPaginate($perPage);

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

        $query = Property::with(['images', 'user'])->where('status', 'approved')
            ->when($request->filled('search'), fn($q) => $q->where(function ($sub) use ($request) {
                $s = $request->input('search');
                $sub->where('address', 'like', "%{$s}%")
                    ->orWhere('city', 'like', "%{$s}%")
                    ->orWhere('governorate', 'like', "%{$s}%")
                    ->orWhere('description', 'like', "%{$s}%")
                    ->orWhere('title', 'like', "%{$s}%");
            }))
            ->when($request->filled('type'), fn($q) => $q->where('type', $request->input('type')))
            ->when($request->filled('price_min'), fn($q) => $q->where('price', '>=', (int) $request->input('price_min')))
            ->when($request->filled('price_max'), fn($q) => $q->where('price', '<=', (int) $request->input('price_max')))
            ->when($request->filled('rooms_min'), fn($q) => $q->where('number_of_rooms', '>=', (int) $request->input('rooms_min')))
            ->when($request->filled('rooms_max'), fn($q) => $q->where('number_of_rooms', '<=', (int) $request->input('rooms_max')))
            ->when($request->filled('baths_min'), fn($q) => $q->where('number_of_baths', '>=', (int) $request->input('baths_min')))
            ->when($request->filled('baths_max'), fn($q) => $q->where('number_of_baths', '<=', (int) $request->input('baths_max')))
            ->when($request->filled('area_min'), fn($q) => $q->where('area', '>=', (int) $request->input('area_min')))
            ->when($request->filled('area_max'), fn($q) => $q->where('area', '<=', (int) $request->input('area_max')))
            ->when($request->filled('city'), fn($q) => $q->where('city', $request->input('city')))
            ->when($request->filled('governorate'), fn($q) => $q->where('governorate', $request->input('governorate')));

        // Map JSON mode: return properties with coords (no pagination)
        if ($request->boolean('map')) {
            $mapQuery = (clone $query)->whereNotNull('latitude')->whereNotNull('longitude');
            if ($request->filled('lat') && $request->filled('lng')) {
                $lat = (float) $request->input('lat');
                $lng = (float) $request->input('lng');
                $haversine = "(6371 * acos(cos(radians(?)) * cos(radians(latitude+0)) * cos(radians(longitude+0) - radians(?)) + sin(radians(?)) * sin(radians(latitude+0))))";
                $mapQuery->selectRaw('properties.*,' . $haversine . ' AS distance', [$lat, $lng, $lat]);
                if ($request->filled('radius_km')) {
                    $mapQuery->having('distance', '<=', (float) $request->input('radius_km'));
                }
                $mapQuery->orderBy('distance');
            }

            $results = $mapQuery->cursorPaginate($perPage);
            return response()->json([
                'data' => $results->map(function ($p) {
                    return [
                        'id' => $p->id,
                        'title' => $p->title,
                        'price' => $p->price,
                        'type' => $p->type,
                        'latitude' => $p->latitude,
                        'longitude' => $p->longitude,
                        'number_of_rooms' => $p->number_of_rooms,
                        'number_of_baths' => $p->number_of_baths,
                        'area' => $p->area,
                        'main_image_url' => $p->main_image_url,
                        'distance' => $p->distance ?? null,
                    ];
                }),
                'meta' => [
                    'next_cursor' => $results->nextCursor()?->encode(),
                    'prev_cursor' => $results->previousCursor()?->encode(),
                    'per_page' => $results->perPage(),
                ],
                'message' => __('validation.property.all_list'),
                'status' => 200,
            ]);
        }



        // Sorting: nearest requires lat & lng
        if ($request->input('sort') === 'nearest' && $request->filled('lat') && $request->filled('lng')) {
            $lat = (float) $request->input('lat');
            $lng = (float) $request->input('lng');
            $haversine = "(6371 * acos(cos(radians(?)) * cos(radians(latitude+0)) * cos(radians(longitude+0) - radians(?)) + sin(radians(?)) * sin(radians(latitude+0))))";
            $query->selectRaw('properties.*,' . $haversine . ' AS distance', [$lat, $lng, $lat]);
            $query->whereNotNull('latitude')->whereNotNull('longitude');
            $query->orderBy('distance')->orderBy('id', 'desc');
        } else {
            if ($request->input('sort') === 'price_asc') {
                $query->orderBy('price', 'asc');
            } elseif ($request->input('sort') === 'price_desc') {
                $query->orderBy('price', 'desc');
            } else {
                $query->orderBy('id', 'desc');
            }
        }

        $properties = $query->cursorPaginate($perPage);

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

    public function all_booked_properties(Request $request, Property $property)
    {
        $perPage = (int) $request->input('per_page', 20);
        $bookings = $property->bookings()->where('status', 'confirmed')->cursorPaginate($perPage);
        return response()->json([
            'data' => $bookings->items(),
            'meta' => [
                'next_cursor' => $bookings->nextCursor()?->encode(),
                'prev_cursor' => $bookings->previousCursor()?->encode(),
                'per_page' => $bookings->perPage(),
            ],
            'message' => __('validation.bookings.returned'),
            'status' => 200,
        ]);
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

        return response()->json([
            'data' => $property,
            'message' => __('validation.property.created'),
        ], 201);
    }

    public function updatestatus(Property $property)
    {
        $property->status = 'approved';
        $property->save();
        return response()->json([
            'message' => 'done',
            'status' => 200,
        ]);
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


        //$isFav = $property->favoritedBy()->where('user_id', auth()->id())->exists();
        $user = $property->user;
        return response()->json([
            'data' => $property,
            'rate' => $rate,
            //'isFav' => $isFav,
            'owner' => $user,
            'message' => __('validation.property.returned'),
        ], 200);
    }

    public function favonwho(Request $request, $propertyId)
    {
        $perPage = (int) $request->input('per_page', 20);

        $property = Property::find($propertyId);

        if (!$property) {
            return response()->json([
                'message' => __('validation.property.not_found'),
                'status' => 404,
            ]);
        }

        $users = $property->favoritedBy()->cursorPaginate($perPage);

        return response()->json([
            'users' => $users->items(),
            'meta' => [
                'next_cursor' => $users->nextCursor()?->encode(),
                'prev_cursor' => $users->previousCursor()?->encode(),
                'per_page' => $users->perPage(),
            ],
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
