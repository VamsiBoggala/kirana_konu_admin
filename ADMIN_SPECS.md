# ADMIN PANEL - PROJECT SPECIFICATIONS

## 1. Project Scope
**Type:** Flutter Web Application
**Role:** Super Admin Dashboard for "Kirana Konu"
**Primary Function:** Verify Hub Owners, Monitor Transactions.

## 2. Authentication System (Email/Password)
Since this is an Admin panel, we do NOT use Phone Auth. We use **Email & Password** because it's standard for desktop use.

**Login Screen Requirements:**
- Fields: Email, Password.
- Validation: Email must look like an email.
- **Security Check:** After Firebase Login, the app MUST check Firestore to ensure the user has `role: 'super_admin'`. If not, logout immediately and show "Access Denied".

## 3. The "Auto-Logout" Session Guard (CRITICAL)
We need a strict 15-minute inactivity timeout.

**Technical Implementation:**
1.  Create a widget named `SessionGuard`.
2.  Wrap the `MaterialApp` (or the authenticated part of the widget tree) with this `SessionGuard`.
3.  **Event Listeners:** The Guard must use a `Listener` widget to detect:
    - `onPointerDown` (Clicks)
    - `onPointerMove` (Mouse movement)
    - `onKeyDown` (Keyboard typing)
4.  **Timer Logic:**
    - On any event, cancel the existing `Timer` and start a new one for **15 minutes**.
    - If the Timer completes (callback triggers), call `AuthService.logout()` and redirect to Login.

## 4. Database & Rules
- **Collection:** `admin_users` (Manually create your admin account here first).
- **Structure:**
  ```json
  {
    "uid": "your_auth_uid",
    "email": "your_email@gmail.com",
    "role": "super_admin"
  }
  ```

## 5. Directory Structure
```
lib/
├── main.dart
├── core/
│   ├── services/
│   │   ├── auth_service.dart
│   │   └── session_timer_service.dart
│   └── widgets/
│       └── session_guard.dart  <-- The Timeout Logic
├── features/
│   ├── auth/
│   │   └── screens/
│   │       └── login_screen.dart
│   └── dashboard/
│       └── screens/
│           └── home_screen.dart
```

## 6. Manual First Step (Important)
Since there is no "Sign Up" screen for Admins (for security), you need to **manually create your Admin Account** once.

1.  Go to Firebase Console -> Authentication -> **Add User**.
2.  Enter your email and a strong password.
3.  Copy the **User UID** created.
4.  Go to Firestore -> Create collection `admin_users`.
5.  Create a document with ID = `{Your UID}`.
6.  Add field: `role: "super_admin"`.

Now, when you build the login screen, you can use those credentials to test the 15-minute timer.

## 7. Architecture
- **State Management:** BLoC (flutter_bloc)
- **Firebase:** Firebase Auth + Firestore
- **Pattern:** Clean Architecture with features-based organization
