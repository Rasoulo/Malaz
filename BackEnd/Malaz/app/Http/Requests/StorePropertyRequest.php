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
            'city' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'governorate' => 'required|string|max:255',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'description' => 'nullable|string|max:1000',
            'images' => 'nullable|array',
            'images.*' => 'nullable|string',
            'type' => 'required|string|in:Apartment,Farm,Villa,Restaurant,Travel Rest Stop,Residential Tower,Country Estate',
            'number_of_rooms' => 'required|min:0|integer',
            'number_of_baths' => 'required|min:0|integer',
            'area' => 'required|min:0',
        ];
    }

    public function messages()
    {
        return [
            'price.required' => 'Price is required.',
            'price.integer' => 'Price must be an integer.',
            'price.min' => 'Price must be zero or greater.',

            'city.required' => 'City is required.',
            'city.string' => 'City must be a valid string.',
            'city.max' => 'City must not exceed 255 characters.',

            'address.required' => 'Address is required.',
            'address.string' => 'Address must be a valid string.',
            'address.max' => 'Address must not exceed 255 characters.',

            'governorate.required' => 'Governorate is required.',
            'governorate.string' => 'Governorate must be a valid string.',
            'governorate.max' => 'Governorate must not exceed 255 characters.',

            'latitude.numeric' => 'Latitude must be a numeric value.',
            'longitude.numeric' => 'Longitude must be a numeric value.',

            'description.string' => 'Description must be a valid string.',
            'description.max' => 'Description must not exceed 1000 characters.',

            'images.array' => 'Images must be an array.',
            'images.*.string' => 'Each image must be a valid string.',

            'type.required' => 'Property type is required.',
            'type.string' => 'Property type must be a valid string.',
            'type.in' => 'Invalid property type. Allowed values: Apartment, Farm, Villa, Restaurant, Travel Rest Stop, Residential Tower, Country Estate.',

            'number_of_rooms.required' => 'Number of rooms is required.',
            'number_of_rooms.integer' => 'Number of rooms must be an integer.',
            'number_of_rooms.min' => 'Number of rooms must be zero or greater.',

            'number_of_baths.required' => 'The number of baths field is required.',
            'number_of_baths.integer' => 'The number of baths must be an integer.',
            'number_of_baths.min' => 'The number of baths cannot be less than 0.',

            'area.required' => 'The area field is required.',
            'area.min' => 'The area must be greater than or equal to 0.',
        ];
    }
}
