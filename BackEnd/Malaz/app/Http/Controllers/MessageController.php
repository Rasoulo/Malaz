<?php

namespace App\Http\Controllers;

use App\Events\MessageDelete;
use App\Models\Message;
use App\Events\MessageRead;
use App\Events\MessageSent;
use App\Models\Conversation;
use Illuminate\Http\Request;
use App\Events\MessageUpdate;

class MessageController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request, Conversation $conversation)
    {
        if ($conversation->user_one_id !== auth()->id() && $conversation->user_two_id !== auth()->id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }
        $perPage = (int) $request->input('per_page', 20);

        $messages = $conversation->messages()
            ->with('sender')
            ->orderBy('id', 'desc')
            ->cursorPaginate($perPage);

        return response()->json([
            'conversation_id' => $conversation->id,
            'messages' => $messages->items(),
            'meta' => [
                'next_cursor' => $messages->nextCursor()?->encode(),
                'prev_cursor' => $messages->previousCursor()?->encode(),
                'per_page' => $messages->perPage(),
            ],
            'status' => 200,
        ]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {

    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request, Conversation $conversation)
    {
        $user = auth()->user();
        $request->validate([
            'body' => 'required|string|min:1|max:1000'
        ]);

        if ($conversation->user_one_id !== auth()->id() && $conversation->user_two_id !== auth()->id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $message = Message::create([
            'sender_id' => $user->id,
            'conversation_id' => $conversation->id,
            'body' => $request->body,
        ]);
        $message->load('sender');

        broadcast(new MessageSent($message))->toOthers();

        return response()->json([
            'message' => 'Message created successfully',
            'data' => $message->load('sender'),
            'status' => 201,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Message $message)
    {
        $conversation = $message->conversation;

        if ($conversation->user_one_id !== auth()->id() && $conversation->user_two_id !== auth()->id()) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        return response()->json([
            'message_data' => $message->load(['sender', 'conversation']),
            'info' => 'Message retrieved successfully',
            'status' => 200,
        ]);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Message $message)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Message $message)
    {
        $request->validate([
            'body' => 'nullable|string',
        ]);

        $user = auth()->user();
        if ($user->id == $message->sender_id) {
            $message->update([
                'body' => $request->body
            ]);
            $message->load('sender');
            broadcast(new MessageUpdate($message))->toOthers();
            return response()->json([
                'message' => 'message updated',
                'status' => 200,
            ]);
        }

        return response()->json([
            'message' => 'you are not the sender',
            'status' => 200,
        ]);
    }

    public function readnow(Message $message)
    {
        $user = auth()->user();

        $conversation = $message->conversation;
        if ($conversation->user_one_id !== $user->id && $conversation->user_two_id !== $user->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        if ($message->sender_id === $user->id) {
            return response()->json(['error' => 'You cannot mark your own message as read'], 400);
        }

        $message->update(['read_at' => now()]);
        $message->load('sender');

        broadcast(new MessageRead($message))->toOthers();

        return response()->json([
            'message' => 'Message marked as read',
            'data' => $message,
            'status' => 200,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Message $message)
    {
        $user = auth()->user();

        if ($user->id !== $message->sender_id) {
            return response()->json([
                'error' => 'Unauthorized',
                'status' => 403,
            ]);
        }

        try {

            broadcast(new MessageDelete($message))->toOthers();
            $message->delete();
            return response()->json([
                'message' => 'message deleted successfully',
            ], 200);

        } catch (\Exception $e) {
            return response()->json(
                [
                    'error' => 'Failed to delete message',
                    'status' => 500,
                ]
            );
        }
    }
}
