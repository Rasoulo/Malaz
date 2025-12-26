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
            'message' => __('validation.user.list'),
            'status' => 200,
        ]);
    }

    public function showProfileImage(User $user)
    {
        $image = base64_decode($user->profile_image);
        return response($image)
            ->header('Content-Type', $user->profile_image_mime);
    }

    public function showIdentityCardImage(User $user)
    {
        // $source = auth()->user();
        // if ($user->id != $source->id && $source->role != 'ADMIN') {
        //     return 9999;
        // }

        $image = base64_decode($user->identity_card_image);
        return response($image)
            ->header('Content-Type', $user->identity_card_mime);
    }

    public function addtofav($propertyId)
    {
        $user = auth()->user();
        $user->favorites()->syncWithoutDetaching([$propertyId]);
        return response()->json([
            'message' => __('validation.user.added_favorite'),
            'status' => 200,
        ]);
    }

    public function erasefromfav($propertyId)
    {
        $user = auth()->user();
        $user->favorites()->detach($propertyId);

        return response()->json([
            'message' => __('validation.user.removed_favorite'),
            'status' => 200,
        ]);
    }

    public function getfav()
    {
        $user = auth()->user();
        $favorites = $user->favorites;

        return response()->json([
            'favorite' => $favorites,
            'message' => __('validation.user.favorite_list'),
            'status' => 200,
        ]);
    }

    public function sendOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|unique:users,phone',
        ]);

        $otp = rand(100000, 999999);

        Cache::put('otp_' . $request->phone, $otp, now()->addMinutes(5));

        app('greenapi')->sendMessage($request->phone, "Verification code: {$otp}");

        return response()->json(['message' => __('validation.user.otp_sent'),]);
    }

    public function sendOtp_passwordone(Request $request)
    {
        $user = auth()->user();
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/|exists:users,phone',
        ]);

        if ($user->phone != $request->phone)
            return response()->json([
                'message' => __('validation.phone.doesnotmatch'),
            ]);



        $otp = rand(100000, 999999);

        Cache::put('otp_' . $request->phone, $otp, now()->addMinutes(5));

        app('greenapi')->sendMessage($request->phone, "Verification code: {$otp}");

        return response()->json(['message' => __('validation.user.otp_sent'),]);
    }

    public function verifyOtp(Request $request)
    {
        $request->validate([
            'phone' => 'required|regex:/^\+?\d{9,15}$/',
            'otp' => 'required|integer'
        ]);

        $cachedOtp = Cache::get('otp_' . $request->phone);

        if (!$cachedOtp) {
            return response()->json(['message' => __('validation.user.otp_expired')], 400);
        }

        if ($cachedOtp != $request->otp) {
            return response()->json(['message' => __('validation.user.otp_invalid')], 400);
        }

        Cache::forget('otp_' . $request->phone);

        $user = User::where('phone', $request->phone)->first();
        if ($user) {
            $user->update(['phone_verified_at' => now()]);
        }
        return response()->json(['message' => __('validation.user.phone_verified')]);
    }

    public function update(UpdateUserRequest $request, User $user)
    {
        $validated = $request->validated();
        $user->update($validated);
        $user->refresh();
        return response()->json([
            'data' => $user,
            'message' => __('validation.user.updated'),
            'status' => 200,
        ]);
    }

    public function showinfo(User $user)
    {
        return response()->json([
            'message' => 'here it is user information',
            'user' => $user,
            'status' => 200,
        ]);
    }

    public function request_update(UpdateUserRequest $request)
    {
        $user = auth()->user();
        $validated = $request->validated();
        $user->update(collect($validated)->except('profile_image')->toArray());
        if ($request->hasFile('profile_image')) {
            $imageData = base64_encode(file_get_contents($request->file('profile_image')->getRealPath()));
            $user->profile_image = $imageData;
            $user->profile_image_mime = $request->file('profile_image')->getMimeType();
        }
        $user->save();
        return response()->json([
            'data' => $user,
            'message' => __('validation.user.edit_request_sent'),
            'status' => 200,
        ]);
    }

    public function updateLanguage(Request $request)
    {
        $request->validate([
            'language' => 'required|string|in:en,ar,fr,ru,tr',
        ]);

        $user = Auth::user();

        $user->language = $request->language;
        $user->save();

        return response()->json([
            'message' => __('validation.user.language_updated'),
            'language' => $user->language,
        ]);
    }



    public function register(RegisterRequest $request)
    {

        $locale = $request->header('Accept-Language', $request->input('language'));

        if (!in_array($locale, ['en', 'ar', 'fr', 'ru', 'tr'])) {
            $locale = config('app.locale');
        }

        $user = User::create([
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'date_of_birth' => $request->date_of_birth,
            'language' => $locale,
        ]);
        if ($request->hasFile('profile_image')) {
            try {
                $imageData = base64_encode(file_get_contents($request->file('profile_image')->getRealPath()));
                $user->profile_image = $imageData;
                $user->profile_image_mime = $request->file('profile_image')->getMimeType();
            } catch (Exception $e) {
                $user->delete();
                return response()->json([
                    'message' => __('validation.user.try_another_image'),
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
                    'message' => __('validation.user.try_another_image'),
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

        return response()->json([
            'message' => __('validation.user.created_pending'),
            'data' => $user
        ], 201);
    }

    public function changepassword(Request $request)
    {
        $request->validate([
            // 'current_password' => 'required',
            'new_password' => 'required|string|min:8|confirmed'
        ]);

        $user = auth()->user();
        // if (!Hash::check($request->current_password, $user->password)) {
        //     return response()->json(['message' => __('validation.user.password_incorrect')], 400);
        // }

        $user->update([
            'password' => Hash::make($request->new_password),
        ]);

        auth()->user()->tokens()->delete();
        
        return response()->json(['message' => __('validation.user.password_updated')], 200);
    }

    public function login(LoginRequest $request)
    {
        if (!Auth::attempt($request->only('phone', 'password'))) {
            return response()->json(['message' => __('validation.user.invalid_credentials')], 401);
        }

        $user = Auth::user();

        if (!$user) {
            return response()->json(['message' => __('validation.user.not_found')], 423);
        }

        if ($user->role === 'PENDING') {
            return response()->json(['message' => __('validation.user.pending_approval')], 403);
        }

        try {
            $token = $user->createToken('api-token')->plainTextToken;
        } catch (Exception $e) {
            return response()->json(['message' => __('validation.user.token_failed')], 500);
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
        return response()->json(['message' => __('validation.user.logged_out')]);
    }

    public function info(User $user)
    {
        return response()->json(auth()->user());
    }
}
