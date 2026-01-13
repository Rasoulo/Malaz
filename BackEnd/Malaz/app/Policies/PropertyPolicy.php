<?php

namespace App\Policies;

use App\Models\User;
use App\Models\Property;
use App\Models\Conversation;
use Illuminate\Auth\Access\Response;

class PropertyPolicy
{
    /**
     * Determine whether the user can view any models.
     */
    public function viewAny(User $user): bool
    {
        return false;
    }

    public function showMessage(User $user, Conversation $conversation)
    {
        return ($conversation->user_one_id === $user->id || $conversation->user_two_id === $user->id)
            ? Response::allow()
            : Response::deny(__('validation.conversation.unauthorized'));
    }

    /**
     * Determine whether the user can view the model.
     */
    public function view(User $user, Conversation $conversation)
    {
        return ($conversation->user_one_id === $user->id || $conversation->user_two_id === $user->id)
            ? Response::allow()
            : Response::deny(__('validation.conversation.unauthorized'));
    }

    /**
     * Determine whether the user can create models.
     */
    public function create(User $user): bool
    {
        return false;
    }

    public function self(User $user, $ownerId)
    {
        return ($user->id !== $ownerId)
            ? Response::allow()
            : Response::deny(__('validation.conversation.self_start'));
    }
    /**
     * Determine whether the user can update the model.
     */
    public function update(User $user, Property $property): bool
    {
        return ($user->role == 'ADMIN' || ($user->role == 'USER' && $property->owner_id == $user->id));
    }

    /**
     * Determine whether the user can delete the model.
     */
    public function delete(User $user, Property $property): bool
    {
        return ($user->role == 'ADMIN' || ($user->role == 'USER' && $property->owner_id == $user->id));
    }

    /**
     * Determine whether the user can restore the model.
     */
    public function restore(User $user, Property $property): bool
    {
        return false;
    }

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function forceDelete(User $user, Property $property): bool
    {
        return false;
    }
}
