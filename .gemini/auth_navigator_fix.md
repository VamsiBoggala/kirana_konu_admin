# Auth Navigator Fix - Navigation Implementation

## Problem
The `AuthNavigator` was directly rendering screens (`LoginScreen` and `HomeScreen`) in the widget tree without using Flutter's navigation system. This caused two issues:
1. Screens appeared directly without being pushed to the navigation stack
2. Routes were not reflected in the browser's address bar because no actual navigation was happening

## Solution
Refactored the `AuthNavigator` from a widget-rendering approach to a proper navigation-based approach:

### Key Changes in `main.dart`:

1. **Converted `AuthNavigator` from StatelessWidget to StatefulWidget**
   - Changed from `BlocBuilder` to `BlocListener` 
   - Now performs actual navigation instead of rendering widgets directly

2. **Initial Navigation in `didChangeDependencies`**
   - Checks the current auth state when the widget is first loaded
   - Uses `Navigator.pushReplacementNamed()` to navigate to the appropriate route
   - Prevents duplicate navigation by checking the current route name

3. **State Change Navigation in `BlocListener`**
   - Listens to `AuthBloc` state changes
   - Navigates to `/dashboard/home` when `AuthAuthenticated`
   - Navigates to `/login` when `AuthUnauthenticated`

4. **Added SessionGuard Integration**
   - Created `_buildAuthenticatedScreen()` helper function
   - Wraps all authenticated screens with `SessionGuard`
   - Maintains the 15-minute inactivity timeout with auto-logout

5. **Loading State**
   - Shows a `CircularProgressIndicator` while navigation is in progress
   - Provides better UX during auth state transitions

## How It Works Now

### Authentication Flow:
1. App starts at `/` route which renders `AuthNavigator`
2. `AuthNavigator` checks the authentication state
3. **If authenticated**: Navigates to `/dashboard/home` (HomeScreen wrapped with SessionGuard)
4. **If unauthenticated**: Navigates to `/login` (LoginScreen)

### State Change Flow:
1. User logs in → `AuthBloc` emits `AuthAuthenticated` state
2. `BlocListener` detects the state change
3. Navigates to `/dashboard/home` using `Navigator.pushReplacementNamed()`
4. Browser URL updates to `/dashboard/home`

### Logout Flow:
1. User logs out or session times out → `AuthBloc` emits `AuthUnauthenticated` state
2. `BlocListener` detects the state change
3. Navigates to `/login` using `Navigator.pushReplacementNamed()`
4. Browser URL updates to `/login`

## Benefits
✅ Routes are now properly reflected in the browser's address bar  
✅ Browser back/forward buttons work correctly  
✅ Deep linking to specific routes is now possible  
✅ Navigation history is properly maintained  
✅ SessionGuard still protects authenticated screens  
✅ Consistent with Flutter's navigation best practices
