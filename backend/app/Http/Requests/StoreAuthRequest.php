<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreAuthRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',

        ];
    }
    public function updateRules(): array
    {
        return [
            'username' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
            'new_password' => 'required|string|min:6',
        ];
    }
    public function message()
    {
        return [
            'username.required' => 'Kolom nama wajib diisi.',
            'username.string' => 'Nama harus berupa string yang valid.',
            'username.max' => 'Nama tidak boleh lebih dari 255 karakter.',

            'email.required' => 'Alamat email wajib diisi.',
            'email.string' => 'Alamat email harus berupa string yang valid.',
            'email.email' => 'Alamat email harus memiliki format email yang valid.',
            'email.max' => 'Alamat email tidak boleh lebih dari 255 karakter.',
            'email.unique' => 'Alamat email sudah terdaftar.',

            'password.required' => 'Kolom kata sandi wajib diisi.',
            'password.string' => 'Kata sandi harus berupa string yang valid.',
            'password.min' => 'Kata sandi harus memiliki panjang minimal 6 karakter.',
            'password.confirmed' => 'Konfirmasi kata sandi tidak cocok.',

            'new_password.required' => 'Kolom kata sandi wajib diisi.',
            'new_password.string' => 'Kata sandi harus berupa string yang valid.',
            'new_password.min' => 'Kata sandi harus memiliki panjang minimal 6 karakter.',

        ];
    }
}
