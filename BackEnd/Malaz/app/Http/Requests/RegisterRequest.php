<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Carbon\Carbon;

class RegisterRequest extends BaseFormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
            //'role' => 'required|string|in:RENTER,OWNER,ADMIN',
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'password' => 'required|string|min:6|confirmed',
            'identity_card_image' => 'required|file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'profile_image' => 'required|file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'date_of_birth' => [
                'required',
                'date',
                'before:' . Carbon::now()->subYears(6)->toDateString(),
            ],
        ];
    }

    public function messages()
{
    return [
        'phone.required' => __('validation.phone.required'),
        'phone.regex'    => __('validation.phone.regex'),
        'phone.unique'   => __('validation.phone.unique'),

        // 'role.required' => 'Role is required.',
        // 'role.string' => 'Role must be a valid string.',
        // 'role.in' => 'The selected role is invalid. Allowed values are: RENTER, OWNER, ADMIN.',

        'first_name.required' => __('validation.first_name.required'),
        'first_name.string'   => __('validation.first_name.string'),

        'last_name.required' => __('validation.last_name.required'),
        'last_name.string'   => __('validation.last_name.string'),

        'password.required'  => __('validation.password.required'),
        'password.string'    => __('validation.password.string'),
        'password.min'       => __('validation.password.min'),
        'password.confirmed' => __('validation.password.confirmed'),

        'identity_card_image.required' => __('validation.identity_card_image.required'),
        'identity_card_image.file'     => __('validation.identity_card_image.file'),
        'identity_card_image.image'    => __('validation.identity_card_image.image'),
        'identity_card_image.mimes'    => __('validation.identity_card_image.mimes'),
        'identity_card_image.max'      => __('validation.identity_card_image.max'),

        'profile_image.required' => __('validation.profile_image.required'),
        'profile_image.file'     => __('validation.profile_image.file'),
        'profile_image.image'    => __('validation.profile_image.image'),
        'profile_image.mimes'    => __('validation.profile_image.mimes'),
        'profile_image.max'      => __('validation.profile_image.max'),

        'date_of_birth.required' => __('validation.date_of_birth.required'),
        'date_of_birth.date'     => __('validation.date_of_birth.date'),
        'date_of_birth.before'   => __('validation.date_of_birth.before'),
    ];
}
}
