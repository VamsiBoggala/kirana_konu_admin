# Logout Navigation Fix

## Problem
When clicking the logout button in the admin sidebar, the user was being logged out (AuthBloc was emitting `AuthUnauthenticated` state) but the app was not navigating back to the login screen.

## Root Cause
The `AuthNavigator` widget (which listens to auth state changes and handles navigation) was only present at the root route `/`. Once the user logged in and navigated to `/dashboard/home`, we cleared the entire navigation stack using `pushNamedAndRemoveUntil()`. This removed the `AuthNavigator` from the widget tree, so it was no longer listening for auth state changes.

When logout occurred:
1. AuthBloc emitted `AuthUnauthenticated` state ✅
2. Firebase auth logged the user out ✅
3. But no widget was listening to navigate to login ❌

## Solution
Added a **global `BlocListener`** that wraps the `MaterialApp` to listen for `AuthUnauthenticated` state changes from anywhere in the app.

### Implementation
Wrapped the `MaterialApp` with a `BlocListener<AuthBloc, AuthState>` that:
1. Listens for `AuthUnauthenticated` state
2. Checks if we're not already on the login or root route (to avoid duplicate navigation)
3. Clears the entire navigation stack using `pushNamedAndRemoveUntil()`
4. Navigates to the login screen

### Code Change (main.dart)

```dart
// Before
child: MaterialApp(...)

// After  
child: BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    // Global listener for logout - navigate to login when unauthenticated
    if (state is AuthUnauthenticated) {
      final navigator = Navigator.of(context);
      final currentRoute = ModalRoute.of(context)?.settings.name;
      
      if (currentRoute != AppRoutes.login && currentRoute != '/') {
        // Clear the stack and navigate to login
        navigator.pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      }
    }
  },
  child: MaterialApp(...),
)
```

## How It Works

### Complete Logout Flow:
1. User clicks logout button in `AdminSidebar`
2. `AuthLogoutRequested` event is added to `AuthBloc`
3. `AuthBloc` calls `AuthService.logout()`
4. Firebase signs out the user
5. `AuthBloc` emits `AuthUnauthenticated` state
6. **Global `BlocListener`** catches this state change
7. Checks current route to prevent duplicate navigation
8. Clears navigation stack completely
9. Navigates to login screen
10. User sees the login screen ✅

### Why This Approach?
- **Global Coverage**: Works from any screen in the app
- **Session Timeout**: Also works for automatic session timeout logout
- **Clean Stack**: Clears all routes when logging out
- **No Duplicates**: Checks current route before navigating
- **Centralized**: Single point of logout navigation logic

## Benefits
✅ Logout now properly navigates to login from any screen  
✅ Session timeout also navigates to login correctly  
✅ Navigation stack is cleared on logout (can't go back to authenticated screens)  
✅ No duplicate navigation attempts  
✅ Single source of truth for logout navigation

## Testing
To test the logout fix:

1. **Manual Logout:**
   - Login to the app
   - Navigate to any page (Home, Hub Requests, etc.)
   - Click the logout button in the sidebar
   - ✅ Should navigate to login screen and show snackbar

2. **Session Timeout:**
   - Login to the app
   - Wait 15 minutes without any activity
   - ✅ Should auto-logout and navigate to login screen with timeout message

3. **Browser Back Button After Logout:**
   - Logout from the app
   - Try pressing browser back button
   - ✅ Should NOT be able to navigate back to authenticated screens
