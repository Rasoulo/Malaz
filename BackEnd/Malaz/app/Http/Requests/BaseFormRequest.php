<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class BaseFormRequest extends FormRequest
{
    protected array $fields = [
        'phone',
        'password',
        'first_name',
        'last_name',
        'identity_card_image',
        'profile_image',
        'date_of_birth',
        'property_id',
        'price',
        'city',
        'address',
        'governorate',
        'latitude',
        'longitude',
        'description',
        'images',
        'erase',
        'type',
        'number_of_rooms',
        'number_of_baths',
        'number_of_bedrooms',
        'area',
        'title',
        'status',
        'rating',
        'number_of_reviews',
        'main_pic',
    ];

    protected function failedValidation($validator)
    {
        $field = array_key_first($validator->errors()->messages());
        $message = $validator->errors()->first();

        $index = array_search($field, $this->fields);
        $status = $index !== false ? $index + 1 : 9999 - 2000;
        $status += 2000;

        throw new HttpResponseException(
            response()->json([
                'message' => $message,
                'status' => $status,
            ], 400)
        );
    }
}