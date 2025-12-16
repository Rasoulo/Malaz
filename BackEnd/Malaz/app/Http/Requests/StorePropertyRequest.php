<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePropertyRequest extends BaseFormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'price' => 'required|integer|min:0',
            'title' => 'required|string|max:255',
            'city' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'governorate' => 'nullable|string|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'description' => 'nullable|string|max:1000',
            'images' => 'nullable|array',
            'main_pic' => 'nullable|file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'images.*' => 'file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'type' => 'required|string|in:Apartment,Farm,Villa,Restaurant,Travel Rest Stop,Residential Tower,Country Estate',
            'number_of_rooms' => 'required|integer|min:0',
            'number_of_baths' => 'required|integer|min:0',
            'number_of_bedrooms' => 'required|integer|min:0',
            'area' => 'required|numeric|min:0',
            'status' => 'prohibited',
            'rating' => 'prohibited',
            'number_of_reviews' => 'prohibited',
        ];
    }

    public function messages()
{
    return [
        'price.required' => __('validation.price.required'),
        'price.integer'  => __('validation.price.integer'),
        'price.min'      => __('validation.price.min'),

        'city.required' => __('validation.city.required'),
        'city.string'   => __('validation.city.string'),
        'city.max'      => __('validation.city.max'),

        'address.required' => __('validation.address.required'),
        'address.string'   => __('validation.address.string'),
        'address.max'      => __('validation.address.max'),

        'governorate.required' => __('validation.governorate.required'),
        'governorate.string'   => __('validation.governorate.string'),
        'governorate.max'      => __('validation.governorate.max'),

        'latitude.numeric'  => __('validation.latitude.numeric'),
        'longitude.numeric' => __('validation.longitude.numeric'),

        'description.string' => __('validation.description.string'),
        'description.max'    => __('validation.description.max'),

        'images.array'     => __('validation.images.array'),
        'images.*.file'    => __('validation.images.file'),
        'images.*.image'   => __('validation.images.image'),
        'images.*.mimes'   => __('validation.images.mimes'),
        'images.*.max'     => __('validation.images.max'),

        'type.required' => __('validation.type.required'),
        'type.string'   => __('validation.type.string'),
        'type.in'       => __('validation.type.in'),

        'number_of_rooms.required' => __('validation.number_of_rooms.required'),
        'number_of_rooms.integer'  => __('validation.number_of_rooms.integer'),
        'number_of_rooms.min'      => __('validation.number_of_rooms.min'),

        'number_of_baths.required' => __('validation.number_of_baths.required'),
        'number_of_baths.integer'  => __('validation.number_of_baths.integer'),
        'number_of_baths.min'      => __('validation.number_of_baths.min'),

        'number_of_bedrooms.required' => __('validation.number_of_bedrooms.required'),
        'number_of_bedrooms.integer'  => __('validation.number_of_bedrooms.integer'),
        'number_of_bedrooms.min'      => __('validation.number_of_bedrooms.min'),

        'area.required' => __('validation.area.required'),
        'area.numeric'  => __('validation.area.numeric'),
        'area.min'      => __('validation.area.min'),

        'title.required' => __('validation.title.required'),
        'title.string'   => __('validation.title.string'),
        'title.max'      => __('validation.title.max'),
    ];
}
}
