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
            'profile_image' => 'string',
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

            'profile_image.string' => __('validation.profile_image.string'),

            'date_of_birth.date' => __('validation.date_of_birth.date'),
            'date_of_birth.before' => __('validation.date_of_birth.before'),
        ];
    }
}
