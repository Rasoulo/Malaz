<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreConversationRequest extends BaseFormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'property_id' => 'required|integer|exists:properties,id',
        ];
    }

    public function messages()
{
    return [
        'property_id.required' => __('validation.property_id.required'),
        'property_id.integer'  => __('validation.property_id.integer'),
        'property_id.exists'   => __('validation.property_id.exists'),
    ];
}
}
