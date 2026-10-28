<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    // Get user's notifications
    public function index(Request $request)
    {
        $notifications = Notification::with('order')
            ->where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json([
            'status' => true,
            'data' => $notifications,
        ]);
    }

    // Mark notification as read
    public function markAsRead(Request $request, $id)
    {
        $notification = Notification::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $notification->update([
            'is_read' => true,
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Notification marked as read.',
            'data' => $notification,
        ]);
    }

    // Mark all notifications as read
    public function markAllAsRead(Request $request)
    {
        Notification::where('user_id', $request->user()->id)
            ->where('is_read', false)
            ->update([
                'is_read' => true,
            ]);

        return response()->json([
            'status' => true,
            'message' => 'All notifications marked as read.',
        ]);
    }

    // Delete notification
    public function destroy(Request $request, $id)
    {
        $notification = Notification::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $notification->delete();

        return response()->json([
            'status' => true,
            'message' => 'Notification deleted.',
        ]);
    }
}