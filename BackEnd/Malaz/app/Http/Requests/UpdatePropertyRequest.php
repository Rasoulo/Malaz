<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePropertyRequest extends FormRequest
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
            'images.*' => 'file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'erase' => 'nullable|array',
            'erase.*' => 'integer',
            'type' => 'string|in:Apartment,Farm,Villa,Restaurant,Travel Rest Stop,Residential Tower,Country Estate',
            'number_of_rooms' => 'integer|min:0',
            'status' => 'prohibited',
            'rating' => 'prohibited',
            'number_of_reviews' => 'prohibited',
            'city' => 'string|max:255',
            'address' => 'string|max:255',
            'governorate' => 'string|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'number_of_baths' => 'integer|min:0',
            'number_of_bedrooms' => 'integer|min:0',
            'area' => 'numeric|min:0',
            'main_pic' => 'nullable|file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ];
    }

    public function messages()
    {
        return [
            'price.integer' => 'The price must be an integer.',
            'price.min' => 'The price must be at least 0.',
            'title.string' => 'The title must be a valid string.',
            'title.max' => 'The title may not be greater than 255 characters.',
            'description.string' => 'The description must be a valid string.',
            'description.max' => 'The description may not be greater than 1000 characters.',
            'images.array' => 'The images field must be an array.',
            'images.*.file' => 'Each image must be a valid file.',
            'images.*.image' => 'Each file must be an image.',
            'images.*.mimes' => 'Images must be of type: jpeg, png, jpg, gif, svg.',
            'images.*.max' => 'Each image may not be larger than 2MB.',
            'erase.array' => 'The erase field must be an array.',
            'erase.*.integer' => 'Each erase item must be an integer.',
            'type.string' => 'The type must be a valid string.',
            'type.in' => 'The type must be one of: Apartment, Farm, Villa, Restaurant, Travel Rest Stop, Residential Tower, Country Estate.',
            'number_of_rooms.integer' => 'The number of rooms must be an integer.',
            'number_of_rooms.min' => 'The number of rooms must be at least 0.',
            'status.prohibited' => 'The status field cannot be set manually.',
            'rating.prohibited' => 'The rating field cannot be set manually.',
            'number_of_reviews.prohibited' => 'The number of reviews field cannot be set manually.',
            'city.string' => 'The city must be a valid string.',
            'city.max' => 'The city may not be greater than 255 characters.',
            'address.string' => 'The address must be a valid string.',
            'address.max' => 'The address may not be greater than 255 characters.',
            'governorate.string' => 'The governorate must be a valid string.',
            'governorate.max' => 'The governorate may not be greater than 255 characters.',
            'latitude.numeric' => 'The latitude must be a valid number.',
            'longitude.numeric' => 'The longitude must be a valid number.',
            'number_of_baths.integer' => 'The number of baths must be an integer.',
            'number_of_baths.min' => 'The number of baths must be at least 0.',
            'number_of_bedrooms.integer' => 'The number of bedrooms must be an integer.',
            'number_of_bedrooms.min' => 'The number of bedrooms must be at least 0.',
            'area.numeric' => 'The area must be a valid number.',
            'area.min' => 'The area must be at least 0.',
            'main_pic.file' => 'main_pic must be a valid file.',
            'main_pic.image' => 'main_pic must be an image.',
            'main_pic.mimes' => 'main_pic must be of type: jpeg, png, jpg, gif, svg.',
            'main_pic..max' => 'main_pic may not be larger than 2MB.',
        ];
    }
}
