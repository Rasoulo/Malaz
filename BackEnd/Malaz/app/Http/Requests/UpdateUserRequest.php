<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Carbon\Carbon;

class UpdateUserRequest extends FormRequest
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
            'identity_card_image' => 'string',
            'date_of_birth' => [
                'date',
                'before:' . Carbon::now()->subYears(6)->toDateString(),
            ],
        ];
    }

    public function messages()
    {
        return [
            'first_name.string' => 'First name must be a valid string.',
            'last_name.string' => 'Last name must be a valid string.',

            'password.string' => 'Password must be a valid string.',
            'password.min' => 'Password must be at least 6 characters long.',

            'identity_card_image.string' => 'Identity card image must be a valid string.',

            'date_of_birth.date' => 'Date of birth must be a valid date.',
            'date_of_birth.before' => 'You must be at least 6 years old.',
        ];
    }
}
