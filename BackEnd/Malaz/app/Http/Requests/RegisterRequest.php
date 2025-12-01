<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Carbon\Carbon;

class RegisterRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'password' => 'required|string|min:6',
            'identity_card_image' => 'required|string',
            'birth_date' => [
                'date',
                'before:' . Carbon::now()->subYears(6)->toDateString(),
            ],
        ];
    }

    public function messages()
    {
        return [
            'phone.required' => 'phone number is required',
            'phone.regex' => 'wrong format with phone number should be only digit or an "+" as the first char',
            'phone.unique' => 'phone number is already exists',
            'first_name.required' => 'first name is required',
            'last_name.required' => 'last name is required',
            'password.required' => 'password is required',
            'password.min' => 'password is too short',
            'identity_card_image.required' => 'identity card image is required',
            'birth_date.before' => 'how some one has less than 6 years to get here',
        ];
    }
}
