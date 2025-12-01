<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use App\Http\Requests\RegisterRequest;
use Illuminate\Database\Eloquent\Casts\Json;

class UserController extends Controller
{
    public function info()
    {
        return response()->json(
            [
                'data' => User::all(),
                'message' => 'all user',
                'status' => 1,
            ]
        );
    }

    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
        ]);

        $otp = rand(100000, 999999);
        Cache::put('otp_' . $request->phone, $otp, now()->addMinutes(5));

        app('greenapi')->sendMessage($request->phone, "Verification code: {$otp}");

        return response()->json(['message' => 'OTP sent']);
    }

    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
            'otp' => 'required|integer'
        ]);

        $cachedOtp = Cache::get('otp_' . $request->phone);

        if (!$cachedOtp) {
            return response()->json(['message' => 'OTP expired or not found'], 400);
        }

        if ($cachedOtp != $request->otp) {
            return response()->json(['message' => 'Invalid OTP','otp' => $cachedOtp], 400);
        }

        Cache::forget('otp_' . $request->phone);

        $user = User::where('phone', $request->phone)->first();
        if ($user) {
            $user->update(['phone_verified_at' => now()]);
        }

        return response()->json(['message' => 'Phone verified']);
    }

    public function register(RegisterRequest $request)
    {
        $user = User::create([
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'phone' => $request->phone,
            'password' => bcrypt($request->password),
            'identity_card_image' => $request->identity_card_image,
            'date_of_birth' => $request->date_of_birth,
        ]);
        $user->fresh();
        return response()->json(['message' => 'User created Wait until it is approved by the officials', 'data' => $user], 201);

    }

    public function login(LoginRequest $request)
    {
        if (!Auth::attempt($request->only('phone', 'password'))) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        $user = Auth::user();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 500);
        }

        if ($user->role === 'PENDING') {
            return response()->json(['message' => 'Wait until it is approved by the officials'], 500);

        }

        try {
            $token = $user->createToken('api-token')->plainTextToken;
        } catch (\Exception $e) {
            return response()->json(['message' => 'Token creation failed'], 500);
        }

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ]);
    }


    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out']);
    }

    public function me(Request $request)
    {
        return response()->json($request->user());
    }
}
