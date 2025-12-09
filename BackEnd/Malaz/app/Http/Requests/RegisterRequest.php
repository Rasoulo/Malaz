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
            // 'role' => 'required|string|in:RENTER,OWNER,ADMIN',
            'role' => '',
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'password' => 'required|string|min:6|confirmed',
            'identity_card_image' => 'required|string',
            'profile_image' => 'required|string',
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
            'phone.required' => 'Phone number is required.',
            'phone.regex' => 'Phone number must be a valid format (9–15 digits, may start with +).',
            'phone.unique' => 'This phone number is already registered.',

            'first_name.required' => 'First name is required.',
            'first_name.string' => 'First name must be a valid string.',

            'last_name.required' => 'Last name is required.',
            'last_name.string' => 'Last name must be a valid string.',

            'password.required' => 'Password is required.',
            'password.string' => 'Password must be a valid string.',
            'password.min' => 'Password must be at least 6 characters long.',

            'identity_card_image.required' => 'Identity card image is required.',
            'identity_card_image.string' => 'Identity card image must be a valid string.',

            'profile_image.required' => 'Profile image is required.',
            'profile_image.string' => 'Profile image must be a valid string.',

            'date_of_birth.required' => 'Date of birth is required.',
            'date_of_birth.date' => 'Date of birth must be a valid date.',
            'date_of_birth.before' => 'You must be at least 6 years old.',

            // 'role.required' => 'The role field is required and cannot be empty.',
            // 'role.string' => 'The role must be a valid string.',
            // 'role.in' => 'The selected role is invalid. Allowed values are: RENTER, OWNER, ADMIN.',
        ];
    }
}
