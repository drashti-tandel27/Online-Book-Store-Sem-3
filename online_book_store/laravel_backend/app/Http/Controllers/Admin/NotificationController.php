<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use App\Models\User;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index()
    {
        $notifications = Notification::with(['user', 'order'])
            ->latest()
            ->paginate(10);

        return view(
            'admin.notifications.index',
            compact('notifications')
        );
    }

    public function create()
    {
        $users = User::orderBy('name')->get();

        return view(
            'admin.notifications.create',
            compact('users')
        );
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
'user_id' => 'required|exists:users,id',
            'title' => 'required|string|max:255',
            'message' => 'required|string',
            'type' => 'required|string|in:info,success,warning,error,order',
        ]);

        $validated['is_read'] = false;

        Notification::create($validated);

        return redirect()
            ->route('admin.notifications.index')
            ->with('success', 'Notification sent successfully.');
    }

    public function show(Notification $notification)
    {
        $notification->load(['user', 'order']);

        return view(
            'admin.notifications.show',
            compact('notification')
        );
    }

    public function destroy(Notification $notification)
    {
        $notification->delete();

        return redirect()
            ->route('admin.notifications.index')
            ->with('success', 'Notification deleted successfully.');
    }

    public function markAsRead(Notification $notification)
    {
        $notification->update([
            'is_read' => true,
        ]);

        return redirect()
            ->route('admin.notifications.index')
            ->with('success', 'Notification marked as read.');
    }
}