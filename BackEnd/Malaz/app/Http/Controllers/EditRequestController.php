<?php

namespace App\Http\Controllers;

use App\Models\EditRequest;
use Illuminate\Http\Request;

class EditRequestController extends Controller
{
    public function index()
    {
        $requests = EditRequest::all();

        return response()->json([
            'data' => $requests,
            'message' => __('messages.edit_request.all_retrieved'),
            'status' => 200,
        ]);
    }

    public function pendinglist()
    {
        $requests = EditRequest::where('status', 'PENDING')->get();

        return response()->json([
            'data' => $requests,
            'message' => __('messages.edit_request.pending_retrieved'),
            'status' => 200,
        ]);
    }

    public function update(Request $request, EditRequest $editRequest)
    {
        $request->validate([
            'status' => 'required|in:APPROVED,REJECTED',
        ]);

        $editRequest->update([
            'status' => $request->status,
            'reviewed_by' => auth()->id(),
            'reviewed_at' => now(),
        ]);

        if ($request->status == 'APPROVED') {
            $editRequest->user()->update($editRequest->new_data);
        }

        return response()->json([
            'data' => $editRequest,
            'message' => __('messages.edit_request.updated'),
            'status' => 200,
        ]);
    }
}