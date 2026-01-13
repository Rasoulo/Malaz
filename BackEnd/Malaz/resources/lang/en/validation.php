<?php

return [

    //'messages.user.created_pending' => 'User created, please wait for admin approval',

    'phone.required' => 'Phone number is required.',
    'phone.regex' => 'Phone number must be in a valid format (9–15 digits, may start with +).',
    'phone.exists' => 'This phone number does not exist in our records.',
    'phone.unique' => 'This phone number is already registered.',
    'phone.doesnotmatch' => 'The phone number you entered does not match the number registered to your account.',

    'password.required' => 'Password is required.',
    'password.string' => 'Password must be a valid string.',
    'password.min' => 'Password must be at least 6 characters long.',
    'password.confirmed' => 'Password confirmation does not match.',

    'first_name.required' => 'First name is required.',
    'first_name.string' => 'First name must be a valid string.',
    'last_name.required' => 'Last name is required.',
    'last_name.string' => 'Last name must be a valid string.',

    'identity_card_image.required' => 'Identity card image is required.',
    'identity_card_image.file' => 'Identity card image must be a file.',
    'identity_card_image.image' => 'Identity card image must be an image.',
    'identity_card_image.mimes' => 'Identity card image must be one of: jpeg, png, jpg, gif, svg.',
    'identity_card_image.max' => 'Identity card image must not exceed 10MB.',

    'profile_image.required' => 'Profile image is required.',
    'profile_image.file' => 'Profile image must be a file.',
    'profile_image.image' => 'Profile image must be an image.',
    'profile_image.mimes' => 'Profile image must be one of: jpeg, png, jpg, gif, svg.',
    'profile_image.max' => 'Profile image must not exceed 10MB.',

    'date_of_birth.required' => 'Date of birth is required.',
    'date_of_birth.date' => 'Date of birth must be a valid date.',
    'date_of_birth.before' => 'You must be at least 6 years old.',

    'property_id.required' => 'Property id is required.',
    'property_id.integer' => 'Property id must be an integer.',
    'property_id.exists' => 'The selected property does not exist.',

    'price.required' => 'Price is required.',
    'price.integer' => 'Price must be an integer.',
    'price.min' => 'Price must be at least 0.',

    'city.required' => 'City is required.',
    'city.string' => 'City must be a valid string.',
    'city.max' => 'City may not be greater than 255 characters.',

    'address.required' => 'Address is required.',
    'address.string' => 'Address must be a valid string.',
    'address.max' => 'Address may not be greater than 255 characters.',

    'governorate.required' => 'Governorate is required.',
    'governorate.string' => 'Governorate must be a valid string.',
    'governorate.max' => 'Governorate may not be greater than 255 characters.',

    'latitude.numeric' => 'Latitude must be a valid number.',
    'longitude.numeric' => 'Longitude must be a valid number.',

    'description.string' => 'Description must be a valid string.',
    'description.max' => 'Description may not be greater than 1000 characters.',

    'images.array' => 'Images must be an array.',
    'images.*.file' => 'Each image must be a valid file.',
    'images.*.image' => 'Each file must be an image.',
    'images.*.mimes' => 'Images must be of type: jpeg, png, jpg, gif, svg.',
    'images.*.max' => 'Each image may not be larger than 10MB.',

    'erase.array' => 'The erase field must be an array.',
    'erase.*.integer' => 'Each erase item must be an integer.',

    'type.required' => 'Type is required.',
    'type.string' => 'Type must be a valid string.',
    'type.in' => 'Type must be one of: Apartment, Farm, Villa, House, Country House.',

    'number_of_rooms.required' => 'Number of rooms is required.',
    'number_of_rooms.integer' => 'Number of rooms must be an integer.',
    'number_of_rooms.min' => 'Number of rooms must be at least 0.',

    'number_of_baths.required' => 'Number of baths is required.',
    'number_of_baths.integer' => 'Number of baths must be an integer.',
    'number_of_baths.min' => 'Number of baths must be at least 0.',

    'number_of_bedrooms.required' => 'Number of bedrooms is required.',
    'number_of_bedrooms.integer' => 'Number of bedrooms must be an integer.',
    'number_of_bedrooms.min' => 'Number of bedrooms must be at least 0.',

    'area.required' => 'Area is required.',
    'area.numeric' => 'Area must be a valid number.',
    'area.min' => 'Area must be at least 0.',

    'title.required' => 'The title field is required.',
    'title.string' => 'The title must be a valid string.',
    'title.max' => 'The title may not be greater than 255 characters.',

    'status.prohibited' => 'The status field cannot be set manually.',
    'rating.prohibited' => 'The rating field cannot be set manually.',
    'number_of_reviews.prohibited' => 'The number of reviews field cannot be set manually.',

    'main_pic.file' => 'main_pic must be a valid file.',
    'main_pic.image' => 'main_pic must be an image.',
    'main_pic.mimes' => 'main_pic must be of type: jpeg, png, jpg, gif, svg.',
    'main_pic.max' => 'main_pic may not be larger than 10MB.',

    'conversation' => [
        'self_start' => 'You cannot start a conversation with yourself',
        'created' => 'Conversation created successfully',
        'exists' => 'Conversation already exists',
        'unauthorized' => 'Unauthorized',
        'show' => 'Here are your conversation',
        'deleted' => 'Conversation deleted successfully',
    ],

    'edit_request' => [
        'all_retrieved' => 'All edit requests retrieved successfully',
        'pending_retrieved' => 'Pending edit requests retrieved successfully',
        'updated' => 'Edit request updated successfully',
    ],

    'message' => [
        'unauthorized' => 'Unauthorized',
        'created' => 'Message created successfully',
        'retrieved' => 'Message retrieved successfully',
        'updated' => 'Message updated successfully',
        'not_sender' => 'You are not the sender',
        'cannot_mark_own' => 'You cannot mark your own message as read',
        'marked_read' => 'Message marked as read',
        'deleted' => 'Message deleted successfully',
        'delete_failed' => 'Failed to delete message',
    ],

    'property' => [
        'my_list' => 'Here are all your properties',
        'all_list' => 'Here are all properties',
        'created' => 'Property created successfully',
        'not_approved' => 'Property not approved',
        'returned' => 'Property returned successfully',
        'not_found' => 'Property not found',
        'favorited_by' => 'All of those love this property',
        'updated' => 'Property updated successfully',
        'deleted' => 'Property deleted successfully',
    ],

    'review' => [
        'all_user_reviews' => 'Here are all your reviews',
        'require_rating_or_body' => 'There should be at least one of the [rating, body] for the review',
        'already_reviewed' => 'You have already reviewed this property.',
        'published' => 'The review was published successfully',
        'must_reserve_before' => 'It is necessary to make a reservation in this apartment before the review.',
        'property_reviews' => 'Here are the property reviews',
        'unauthorized' => 'Unauthorized',
        'updated' => 'Review updated successfully',
        'deleted' => 'Review deleted successfully',
    ],

    'user' => [
        'list' => 'List of all users',
        'added_favorite' => 'Added to favorites successfully',
        'removed_favorite' => 'Removed from favorites successfully',
        'favorite_list' => 'Here is your favorite list',
        'otp_sent' => 'OTP sent successfully',
        'otp_expired' => 'OTP expired or not found',
        'otp_invalid' => 'Invalid OTP',
        'phone_verified' => 'Phone verified successfully',
        'updated' => 'User updated successfully',
        'edit_request_sent' => 'Edit request sent, wait until it is approved by the officials',
        'language_updated' => 'Language updated successfully',
        'try_another_image' => 'Try another image',
        'created_pending' => 'User created, wait until it is approved by the officials',
        'password_incorrect' => 'Current password is incorrect',
        'password_updated' => 'Password updated successfully',
        'invalid_credentials' => 'Invalid credentials',
        'not_found' => 'User not found',
        'pending_approval' => 'Wait until it is approved by the officials',
        'token_failed' => 'Token creation failed',
        'logged_out' => 'Logged out successfully',
    ],

    'bookings' => [
        'returned' => 'Confirmed bookings have been returned successfully.',
    ],

    'password.max' => 'The password must not exceed 40 characters.',

    'first_name.max' => 'The first name must not exceed 31 characters.',
    'last_name.max' => 'The last name must not exceed 31 characters.',
    'number_of_rooms' => [
        'max' => 'The number of rooms must not exceed 100.',
    ],
    'number_of_baths' => [
        'max' => 'The number of baths must not exceed 100.',
    ],
    'number_of_bedrooms' => [
        'max' => 'The number of bedrooms must not exceed 100.',
    ],
    'area' => [
        'max' => 'The area must not exceed 100000.',
    ],

    'price' => [
        'max' => 'The price must not exceed 100000000.',
    ],

];