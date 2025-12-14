<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Carbon\Carbon;

class LoginRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'phone' => 'required|regex:/^\+?\d{9,15}$/|exists:users,phone',
            'password' => 'required|string|min:6',
        ];
    }

    public function messages()
{
    return [
        'phone.required' => __('validation.phone.required'),
        'phone.regex'    => __('validation.phone.regex'),
        'phone.exists'   => __('validation.phone.exists'),

        'password.required' => __('validation.password.required'),
        'password.string'   => __('validation.password.string'),
        'password.min'      => __('validation.password.min'),
    ];
}
}
