# Session Timeout Testing Guide

## ✅ What's Already Implemented

The session timeout feature is **fully functional** with these components:

1. **SessionTimerService** - Manages the 15-minute inactivity timer
2. **SessionGuard** - Monitors user activity (mouse, keyboard, hover)
3. **Auto-logout** - Automatically logs out after timeout

## 🧪 How to Test

### Quick Test (1 Minute Timeout)

1. Open `lib/core/config/session_config.dart`
2. Change line 12 to:
   ```dart
   static const Duration timeoutDuration = Duration(minutes: 1);
   ```
3. Save and hot reload/restart the app
4. Log in to the admin panel
5. Watch the console for debug messages
6. **Don't touch anything** for 1 minute
7. You should see:
   - "⏰ Session Timer: TIMEOUT! Triggering auto-logout..."
   - Automatic logout
   - Orange snackbar: "Session expired due to inactivity"
   - Redirect to login screen

### Production Test (15 Minutes)

Keep the default setting:
```dart
static const Duration timeoutDuration = Duration(minutes: 15);
```

## 📋 Debug Console Messages

When testing, you'll see these messages in the console:

1. **On Login:**
   ```
   🔒 Session Timer: Initialized with 1 minute timeout
   ⏱️  Session Timer: Started - Will timeout at 17:35:20
   ```

2. **On User Activity** (mouse move, click, key press):
   ```
   🔄 Session Timer: Reset - User activity detected
   ⏱️  Session Timer: Started - Will timeout at 17:36:20
   ```

3. **On Timeout:**
   ```
   ⏰ Session Timer: TIMEOUT! Triggering auto-logout...
   ```

4. **On Logout:**
   ```
   🛑 Session Timer: Disposed
   ```

## 🔍 What Resets the Timer

The timer resets on any of these activities:
- ✅ Mouse clicks
- ✅ Mouse movement
- ✅ Mouse hover
- ✅ Keyboard input (any key)

## 🐛 Turn Off Debug Logs

To disable debug logging in production:

In `lib/core/config/session_config.dart`, change line 14 to:
```dart
static const bool enableDebugLogs = false;
```

## ✨ Production Configuration

Before deploying to production:

```dart
class SessionConfig {
  static const Duration timeoutDuration = Duration(minutes: 15);
  static const bool enableDebugLogs = false;  // Disable logs in production
}
```

## 🎯 Expected Behavior

**Scenario 1: Active User**
- User is using the admin panel
- Clicks buttons, types, moves mouse
- Session stays active indefinitely
- ✅ No logout

**Scenario 2: Inactive User**
- User logs in
- Leaves computer idle for 15 minutes
- Timer expires
- Auto-logout triggered
- User sees "Session expired" message
- Redirected to login screen
- ✅ Logout successful

**Scenario 3: Partially Active User**
- User logs in at 5:00 PM
- Works until 5:10 PM (timer resets)
- Goes idle from 5:10 PM to 5:25 PM (15 minutes)
- Auto-logout at 5:25 PM
- ✅ Logout successful

## 📝 Notes

- The timer uses a **singleton** pattern - one timer for the entire session
- Timer is **disposed** on logout to prevent memory leaks
- FocusNode is properly managed (created in initState, disposed in dispose)
- Works on all authenticated screens automatically
