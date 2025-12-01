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
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
            'password' => 'required|string|min:6',
        ];
    }

    public function messages()
    {
        return [
            'phone.required' => 'phone number is required',
            'phone.regex' => 'wrong format with phone number should be only digit or an "+" as the first char',
            'phone.unique' => 'phone number is already exists',
            'password.required' => 'password is required',
            'password.min' => 'password is too short',
        ];
    }
}
