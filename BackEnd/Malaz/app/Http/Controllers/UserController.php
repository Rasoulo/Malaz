<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\EditRequest;
use Exception;
use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Cache;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\UpdateUserRequest;

class UserController extends Controller
{

    public function index()
    {
        return response()->json([
            'data' => User::all()->makeHidden(['profile_image', 'identity_card_image']),
            'message' => 'list of all user',
            'status' => 200,
        ]);
    }

    // public function profileImage($id)
    // {
    //     $user = User::findOrFail($id);

    //     return response($user->profile_image)
    //         ->header('Content-Type', $user->mime_type);
    // }

    // public function identityImage($id)
    // {
    //     $user = User::findOrFail($id);

    //     return response($user->identity_image)
    //         ->header('Content-Type', $user->mime_type);
    // }

    public function showProfileImage(User $user)
    {
        $image = base64_decode($user->profile_image);
        return response($image)
            ->header('Content-Type', $user->profile_image_mime);
    }

    public function showIdentityCardImage(User $user)
    {
        $image = base64_decode($user->identity_card_image);
        return response($image)
            ->header('Content-Type', $user->identity_card_mime);
    }

    public function addtofav($propertyId)
    {
        $user = auth()->user();
        $user->favorites()->syncWithoutDetaching([$propertyId]);
        return response()->json([
            'message' => 'added to favorite completed',
            'status' => 200,
        ]);
    }

    public function erasefromfav($propertyId)
    {
        $user = auth()->user();
        $user->favorites()->detach($propertyId);

        return response()->json([
            'message' => 'removed from favorite completed',
            'status' => 200,
        ]);
    }

    public function getfav()
    {
        $user = auth()->user();
        $favorites = $user->favorites;

        return response()->json([
            'favorite' => $favorites,
            'message' => 'here all your favorite list',
            'status' => 200,
        ]);
    }

    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
        ]);

        $otp = rand(100000, 999999);
        //$otp = 111111;
        Cache::put('otp_' . $request->phone, $otp, now()->addMinutes(5));

        app('greenapi')->sendMessage($request->phone, "Verification code: {$otp}");

        return response()->json(['message' => 'OTP sent']);
    }

    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/',
            'otp' => 'required|integer'
        ]);

        $cachedOtp = Cache::get('otp_' . $request->phone);

        if (!$cachedOtp) {
            return response()->json(['message' => 'OTP expired or not found'], 400);
        }

        if ($cachedOtp != $request->otp) {
            return response()->json(['message' => 'Invalid OTP'], 400);
        }

        Cache::forget('otp_' . $request->phone);

        $user = User::where('phone', $request->phone)->first();
        if ($user) {
            $user->update(['phone_verified_at' => now()]);
        }

        return response()->json(['message' => 'Phone verified']);
    }

    public function update(UpdateUserRequest $request, User $user)
    {
        $validated = $request->validated();
        $user->update($validated);
        $user->refresh();
        return response()->json([
            'data' => $user,
            'message' => 'user update completed',
            'status' => 200,
        ]);
    }

    public function request_update(UpdateUserRequest $request)
    {
        $user = auth()->user();
        $editrequest = EditRequest::create([
            'user_id' => $user->id,
            'old_data' => $user->toArray(),
            'new_data' => $request->validated(),
            'status' => 'PENDING',
        ]);
        return response()->json([
            'data' => $editrequest,
            'message' => 'Send the edit request , Wait until it is approved by the officials',
            'status' => 200,
        ]);
    }


    public function register(RegisterRequest $request)
    {
        $user = User::create([
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'date_of_birth' => $request->date_of_birth,
        ]);
        if ($request->hasFile('profile_image')) {
            try {
                $imageData = base64_encode(file_get_contents($request->file('profile_image')->getRealPath()));
                $user->profile_image = $imageData;
                $user->profile_image_mime = $request->file('profile_image')->getMimeType();
            } catch (Exception $e) {
                $user->delete();
                return response()->json([
                    'message' => 'try another image',
                    'status' => 400,
                ]);
            }
        }

        if ($request->hasFile('identity_card_image')) {
            try {
                $imageData = base64_encode(file_get_contents($request->file('identity_card_image')->getRealPath()));
                $user->identity_card_image = $imageData;
                $user->identity_card_mime = $request->file('identity_card_image')->getMimeType();
            } catch (Exception $e) {
                $user->delete();
                return response()->json([
                    'message' => 'try another image',
                    'status' => 400,
                ]);
            }
        }

        $user->save();

        // $data = $request->validated();
        // $data['role'] = 'USER';
        $user->refresh();
        // $editrequest = EditRequest::create([
        //     'user_id' => $user->id,
        //     'old_data' => collect($user->toArray())->except(['password']),
        //     'new_data' => collect($data)->except(['password']),
        //     'status' => 'PENDING',
        // ]);

        return response()->json(['message' => 'User created Wait until it is approved by the officials', 'data' => $user], 201);
    }

    public function changepassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|string|min:8|confirmed'
        ]);

        $user = auth()->user();
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'Current password is incorrect'
            ], 400);
        }

        $user->update([
            'password' => Hash::make($request->new_password),
        ]);

        auth()->user()->tokens()->delete();

        return response()->json([
            'message' => 'Password updated successfully'
        ], 200);

    }

    public function login(LoginRequest $request)
    {
        if (!Auth::attempt($request->only('phone', 'password'))) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        $user = Auth::user();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 423);
        }

        if ($user->role === 'PENDING') {
            return response()->json(['message' => 'Wait until it is approved by the officials'], 403);

        }

        try {
            $token = $user->createToken('api-token')->plainTextToken;
        } catch (Exception $e) {
            return response()->json(['message' => 'Token creation failed'], 500);
        }

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ]);
    }


    public function logout()
    {
        auth()->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out']);
    }

    public function me()
    {
        return response()->json(auth()->user());
    }
}
