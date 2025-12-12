<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePropertyRequest extends FormRequest
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
            'price.required' => 'Price is required.',
            'price.integer' => 'Price must be an integer.',
            'price.min' => 'Price cannot be less than zero.',
            'city.required' => 'City is required.',
            'city.string' => 'City must be a string.',
            'city.max' => 'City cannot exceed 255 characters.',
            'address.required' => 'Address is required.',
            'address.string' => 'Address must be a string.',
            'address.max' => 'Address cannot exceed 255 characters.',
            'governorate.required' => 'Governorate is required.',
            'governorate.string' => 'Governorate must be a string.',
            'governorate.max' => 'Governorate cannot exceed 255 characters.',
            'latitude.numeric' => 'Latitude must be a number.',
            'longitude.numeric' => 'Longitude must be a number.',
            'description.string' => 'Description must be a string.',
            'description.max' => 'Description cannot exceed 1000 characters.',
            'images.array' => 'Images must be an array.',
            'images.*.file' => 'Each image must be a file.',
            'images.*.image' => 'Each file must be an image.',
            'images.*.mimes' => 'Images must be of type: jpeg, png, jpg, gif, svg.',
            'images.*.max' => 'Each image must not exceed 2MB.',
            'type.required' => 'Type is required.',
            'type.string' => 'Type must be a string.',
            'type.in' => 'Type must be one of: Apartment, Farm, Villa, Restaurant, Travel Rest Stop, Residential Tower, Country Estate.',
            'number_of_rooms.required' => 'Number of rooms is required.',
            'number_of_rooms.integer' => 'Number of rooms must be an integer.',
            'number_of_rooms.min' => 'Number of rooms cannot be less than zero.',
            'number_of_baths.required' => 'Number of baths is required.',
            'number_of_baths.integer' => 'Number of baths must be an integer.',
            'number_of_baths.min' => 'Number of baths cannot be less than zero.',
            'number_of_bedrooms.required' => 'Number of bedrooms is required.',
            'number_of_bedrooms.integer' => 'Number of bedrooms must be an integer.',
            'number_of_bedrooms.min' => 'Number of bedrooms cannot be less than zero.',
            'area.required' => 'Area is required.',
            'area.numeric' => 'Area must be a number.',
            'area.min' => 'Area cannot be less than zero.',
            'title.required' => 'The title field is required.',
            'title.string' => 'The title must be a valid string.',
            'title.max' => 'The title may not be greater than 255 characters.',
        ];
    }
}
