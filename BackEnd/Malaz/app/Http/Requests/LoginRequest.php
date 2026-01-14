<?php

namespace App\Http\Requests;

use Carbon\Carbon;
use Illuminate\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class LoginRequest extends BaseFormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'phone' => 'required|regex:/^\+?\d{8,15}$/|exists:users,phone',
            'password' => 'required|string|min:6|max:40',
        ];
    }

    public function messages()
    {
        return [
            'phone.required' => __('validation.phone.required'),
            'phone.regex' => __('validation.phone.regex'),
            'phone.exists' => __('validation.phone.exists'),

            'password.required' => __('validation.password.required'),
            'password.string' => __('validation.password.string'),
            'password.min' => __('validation.password.min'),
            'password.max' => __('validation.password.max'),
        ];
    }
}
