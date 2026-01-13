<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePropertyRequest extends BaseFormRequest
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
            'price' => 'integer|min:0',
            'title' => 'string|max:255',
            'description' => 'nullable|string|max:1000',
            'images' => 'nullable|array',
            'images.*' => 'file|image|mimes:jpeg,png,jpg,gif,svg|max:10240',
            'erase' => 'nullable|array',
            'erase.*' => 'integer',
            'type' => 'string|in:Apartment,Farm,Villa,House,Country House',
            'status' => 'prohibited',
            'rating' => 'prohibited',
            'number_of_reviews' => 'prohibited',
            'city' => 'string|max:255',
            'address' => 'string|max:255',
            'governorate' => 'string|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'number_of_rooms' => 'integer|min:0|max:100',
            'number_of_baths' => 'integer|min:0|max:100',
            'number_of_bedrooms' => 'integer|min:0|max:100',
            'area' => 'numeric|min:0|max:100000',
            'main_pic' => 'nullable|file|image|mimes:jpeg,png,jpg,gif,svg|max:10240',
        ];
    }

    public function messages()
    {
        return [
            'price.integer' => __('validation.price.integer'),
            'price.min' => __('validation.price.min'),

            'title.string' => __('validation.title.string'),
            'title.max' => __('validation.title.max'),

            'description.string' => __('validation.description.string'),
            'description.max' => __('validation.description.max'),

            'images.array' => __('validation.images.array'),
            'images.*.file' => __('validation.images.file'),
            'images.*.image' => __('validation.images.image'),
            'images.*.mimes' => __('validation.images.mimes'),
            'images.*.max' => __('validation.images.max'),

            'erase.array' => __('validation.erase.array'),
            'erase.*.integer' => __('validation.erase.integer'),

            'type.string' => __('validation.type.string'),
            'type.in' => __('validation.type.in'),

            'number_of_rooms.integer' => __('validation.number_of_rooms.integer'),
            'number_of_rooms.min' => __('validation.number_of_rooms.min'),

            'status.prohibited' => __('validation.status.prohibited'),
            'rating.prohibited' => __('validation.rating.prohibited'),
            'number_of_reviews.prohibited' => __('validation.number_of_reviews.prohibited'),

            'city.string' => __('validation.city.string'),
            'city.max' => __('validation.city.max'),

            'address.string' => __('validation.address.string'),
            'address.max' => __('validation.address.max'),

            'governorate.string' => __('validation.governorate.string'),
            'governorate.max' => __('validation.governorate.max'),

            'latitude.numeric' => __('validation.latitude.numeric'),
            'longitude.numeric' => __('validation.longitude.numeric'),

            'number_of_baths.integer' => __('validation.number_of_baths.integer'),
            'number_of_baths.min' => __('validation.number_of_baths.min'),

            'number_of_bedrooms.integer' => __('validation.number_of_bedrooms.integer'),
            'number_of_bedrooms.min' => __('validation.number_of_bedrooms.min'),

            'area.numeric' => __('validation.area.numeric'),
            'area.min' => __('validation.area.min'),

            'main_pic.file' => __('validation.main_pic.file'),
            'main_pic.image' => __('validation.main_pic.image'),
            'main_pic.mimes' => __('validation.main_pic.mimes'),
            'main_pic.max' => __('validation.main_pic.max'),

            'number_of_rooms.max' => __('validation.number_of_rooms.max'),
            'number_of_baths.max' => __('validation.number_of_baths.max'),
            'number_of_bedrooms.max' => __('validation.number_of_bedrooms.max'),
            'area.max' => __('validation.area.max'),

        ];
    }
}
