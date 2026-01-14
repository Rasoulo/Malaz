<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Message;
use App\Models\Conversation;
use Illuminate\Http\Request;
use App\Http\Requests\UpdateConversationRequest;

class ConversationController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $user = auth()->user();

        $perPage = (int) $request->input('per_page', 20);

        $conversations = Conversation::where('user_one_id', $user->id)
            ->orWhere('user_two_id', $user->id)
            ->with(['userOne', 'userTwo'])
            ->withCount([
                    'messages as unread_count' => function ($query) use ($user) {
                        $query->whereNull('read_at')
                            ->where('sender_id', '!=', $user->id);
                    }
                ])
            ->orderByDesc(
                Message::select('created_at')
                    ->whereColumn('conversation_id', 'conversations.id')
                    ->latest()
                    ->take(1)
            )
            ->cursorPaginate($perPage);

        return response()->json([
            'conversations' => $conversations->items(),
            'meta' => [
                'next_cursor' => $conversations->nextCursor()?->encode(),
                'prev_cursor' => $conversations->previousCursor()?->encode(),
                'per_page' => $conversations->perPage(),
            ],
            'status' => 200,
        ], 200);
    }
    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store($userId)
    {
        $owner = User::findOrFail($userId);
        $user = auth()->user();

        // $this->authorize('self', $owner);

        if ($owner->id === $user->id) {
            return response()->json(['error' => __('validation.conversation.unauthorized')], 403);
        }

        $ids = [$user->id, $owner->id];
        sort($ids);

        $conversation = Conversation::firstOrCreate([
            'user_one_id' => $ids[0],
            'user_two_id' => $ids[1],
        ]);

        return response()->json([
            'message' => $conversation->wasRecentlyCreated
                ? __('validation.conversation.created')
                : __('validation.conversation.exists'),
            'conversation' => $conversation,
            'status' => $conversation->wasRecentlyCreated ? 201 : 200,
        ], $conversation->wasRecentlyCreated ? 201 : 200);


    }

    /**
     * Display the specified resource.
     */
    public function show(Conversation $conversation)
    {
        // $this->authorize('view', $conversation);
        $user = auth()->user();
        if ($conversation->user_one_id !== $user->id && $conversation->user_two_id !== $user->id)
            return response()->json(['error' => __('validation.conversation.unauthorized')], 400);
        // : Response::deny(__('validation.conversation.unauthorized'));
        return response()->json([
            'message' => __('validation.conversation.show'),
            'conversation' => $conversation,
            'status' => 200,
        ], 200);

    }

    public function showmessage(Request $request, Conversation $conversation)
    {
        return 1;
        // $this->authorize('showMessage', $conversation);
        $user = auth()->user();
        if ($conversation->user_one_id !== $user->id || $conversation->user_two_id !== $user->id)
            return response()->json(['error' => __('validation.conversation.unauthorized')], 400);

        // ? Response::allow()
        // : Response::deny(__('validation.conversation.unauthorized'));

        $conversation->messages()
            ->whereNull('read_at')
            ->where('sender_id', '!=', auth()->id())
            ->updateQuietly(['read_at' => now()]);

        $perPage = (int) $request->input('perpage', 20);
        $messages = $conversation->messages()->with('sender')->latest()->cursorPaginate($perPage);
        
        return response()->json([
            'message' => __('validation.conversation.show'),
            'last_messages' => $messages,
            'meta' => [
                'next_cursor' => $messages->nextCursor()?->encode(),
                'prev_cursor' => $messages->previousCursor()?->encode(),
                'per_page' => $messages->perPage(),
            ],
            'status' => 200,
        ], 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Conversation $conversation)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateConversationRequest $request, Conversation $conversation)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Conversation $conversation)
    {
        // $this->authorize('delete', $conversation);

        if ($conversation->user_one_id !== auth()->id() && $conversation->user_two_id !== auth()->id()) {
            return response()->json(['error' => __('validation.conversation.unauthorized')], 403);
        }

        $conversation->delete();
        return response()->json([
            'message' => __('validation.conversation.deleted'),
            'status' => 200,
        ], 200);

    }
}
