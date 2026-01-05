<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Carbon\Carbon;

class UpdateUserRequest extends BaseFormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'first_name' => 'string',
            'last_name' => 'string',
            'profile_image' => 'required|file|image|mimes:jpeg,png,jpg,gif,svg|max:10240',
            'date_of_birth' => [
                'date',
                'before:' . Carbon::now()->subYears(6)->toDateString(),
            ],
        ];
    }

    public function messages()
    {
        return [
            'first_name.string' => __('validation.first_name.string'),
            'last_name.string' => __('validation.last_name.string'),

            'password.string' => __('validation.password.string'),
            'password.min' => __('validation.password.min'),

            'profile_image.required' => __('validation.profile_image.required'),
            'profile_image.file' => __('validation.profile_image.file'),
            'profile_image.image' => __('validation.profile_image.image'),
            'profile_image.mimes' => __('validation.profile_image.mimes'),
            'profile_image.max' => __('validation.profile_image.max'),

            'date_of_birth.date' => __('validation.date_of_birth.date'),
            'date_of_birth.before' => __('validation.date_of_birth.before'),
        ];
    }
}
