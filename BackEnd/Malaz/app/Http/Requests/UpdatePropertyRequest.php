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
            'is_rented' => 'boolean',
            'price' => 'integer|min:0',
            'description' => 'nullable|string|max:1000',
            'images' => 'nullable|array',
            'images.*' => 'string',
            'erase' => 'nullable|array',
            'erase.*' => 'integer',
            'type' => 'string|in:Apartment,Farm,Villa,Restaurant,Travel Rest Stop,Residential Tower,Country Estate',
            'number_of_rooms' => 'min:0|integer'
        ];
    }

    public function messages()
    {
        return
            [
                'is_rented.boolean' => 'The rented field must be true or false.',
                'price.integer' => 'The price must be a valid integer.',
                'price.min' => 'The price cannot be less than zero.',
                'description.string' => 'The description must be a valid string.',
                'description.max' => 'The description may not be greater than 1000 characters.',
                'images.array' => 'Images must be provided as an array.',
                'images.*.string' => 'Each image must be a valid string (Base64).',
                'erase.array' => 'Erase must be provided as an array of IDs.',
                'erase.*.integer' => 'Each erase item must be a valid integer ID.',
                'type.string' => 'Property type must be a valid string.',
                'type.in' => 'Invalid property type. Allowed values: Apartment, Farm, Villa, Restaurant, Travel Rest Stop, Residential Tower, Country Estate.',
                'number_of_rooms.integer' => 'Number of rooms must be an integer.',
                'number_of_rooms.min' => 'Number of rooms must be zero or greater.',
            ];
    }
}
