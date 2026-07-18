# AI Developer Guide - Jurisheba (`my_structure`)

This document serves as a developer guide for other AI coding assistants (such as Claude, ChatGPT, or Gemini). It provides the core design patterns, structural conventions, and screen details of the **Jurisheba** project, allowing immediate work on the codebase without deep manual file exploration.

---

## 🏗️ Design Patterns & Code Style Conventions

### 1. GetX State Management & Dependency Injection
- Do **not** use `StatefulWidget` for managing business logic. Use `GetxController` instead.
- Use `Obx` or `GetX` builder widgets in views to listen to reactive variable changes (e.g. `final name = "".obs;`).
- Declare dependencies in a GetX `Binding` class (located inside `bindings/` of each module) and register them in `lib/app/routes/app_pages.dart`.
- Prefer using `Get.lazyPut<Controller>(() => Controller())` in bindings.

### 2. Responsive UI Architecture (Mobile, Tablet, Desktop)
Every page view in the app follows a responsive dispatcher pattern:
- **`*_view.dart`**: Extends `GetView<Controller>`. It contains a `LayoutBuilder` that measures constraints.
  ```dart
  class FeatureView extends GetView<FeatureController> {
    const FeatureView({super.key});

    @override
    Widget build(BuildContext context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) return const FeatureDesktop();
          if (constraints.maxWidth > 600) return const FeatureTablet();
          return const FeatureMobile();
        },
      );
    }
  }
  ```
- **`*_mobile.dart` / `*_tablet.dart` / `*_desktop.dart`**: These files use `part of 'feature_view.dart';` at the top and do **not** repeat imports or binding registration. The UI widgets themselves go here.

### 3. Local Storage Wrapper
- Do **not** use raw `GetStorage` boxes or `SharedPreferences` direct calls.
- Use the unified `LocalStorage` static helper class defined in `lib/app/core/services/local_storage_service.dart`.
- Commonly used:
  - `LocalStorage.isLoggedIn()` - Check authentication state.
  - `LocalStorage.getName()`, `LocalStorage.getEmail()`, `LocalStorage.getPhone()`.
  - `LocalStorage.saveLanguage(...)` - Save and apply locale.
  - `LocalStorage.switchTheme()` - Toggles app theme and updates the GetX ThemeMode.

### 4. Internationalization & Strings
- Do **not** hardcode raw strings in user-facing UI.
- Use GetX internationalization by appending `.tr` to keys.
- Translation keys are centralized in [translations.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/core/localization/translations.dart) for both **Bangla ('bn')** and **English ('en')**.

---

## 📱 Detailed Screen & Module Index

When updating or debugging a screen, consult this index to locate controllers and view structures:

### 1. Splash Module
- **Path**: `lib/app/modules/splash/`
- **Controller**: [splash_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/splash/controllers/splash_controller.dart)
- **View Files**: `views/splash_view.dart`, `views/splash_mobile.dart`, `views/splash_tablet.dart`
- **Flow**: Runs animation, validates `LocalStorage.isLoggedIn()` or onboarding configuration, and redirects.

### 2. Language Selection Module
- **Path**: `lib/app/modules/language_selection/`
- **Controller**: [language_selection_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/language_selection/controllers/language_selection_controller.dart)
- **View Files**: `views/language_selection_view.dart`, `views/language_selection_mobile.dart`
- **Widgets**: `widgets/language_card.dart`
- **Flow**: Updates locale key in storage and pushes user to onboarding (`/onboard`).

### 3. Onboard Module
- **Path**: `lib/app/modules/onboard/`
- **Controller**: [onboard_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/onboard/controllers/onboard_controller.dart)
- **View Files**: `views/onboard_view.dart`, `views/onboard_mobile.dart`
- **Widgets**: `widgets/onboard_page.dart` (visual carousel item layout)
- **Flow**: Standard horizontal three-stage tutorial showing emoji iconography and app features.

### 4. Authentication Modules
- **Login Path**: `lib/app/modules/auth/login/`
  - **Controller**: [login_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/auth/login/controllers/login_controller.dart)
  - **View Files**: `views/login_view.dart`, `views/login_mobile.dart`
  - **Flow**: Asks for phone number, sends code, then displays OTP code inputs powered by `pinput`.
- **Registration Path**: `lib/app/modules/auth/registration/`
  - **Controller**: [registration_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/auth/registration/controllers/registration_controller.dart)
  - **View Files**: `views/registration_view.dart`, `views/registration_mobile.dart`
  - **Flow**: Registers new profile containing Full Name, Phone, Email, District/City, and Gender selections.

### 5. Bottom Nav Module (Main Container Shell)
- **Path**: `lib/app/modules/bottom_nav/`
- **Controller**: [bottom_nav_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/bottom_nav/controllers/bottom_nav_controller.dart)
- **View Files**: `views/bottom_nav_view.dart`
- **Flow**: Manages `currentIndex` for the main persistent tabs (Home, Bookings, Finder, Profile).

### 6. Home Module
- **Path**: `lib/app/modules/home/`
- **Controller**: [home_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/home/controllers/home_controller.dart)
- **View Files**: `views/home_view.dart`, `views/home_mobile.dart`
- **Flow**: User home containing horizontal list selector for lawyer specialties, quick access links, and lawyer overview summaries.

### 7. Lawyer Details Module
- **Path**: `lib/app/modules/lawyer_details/`
- **Controller**: `controllers/lawyer_details_controller.dart`
- **View Files**: `views/lawyer_details_view.dart`, `views/lawyer_details_mobile.dart`
- **Flow**: Renders specific stats, education certificates, and reviews. Contains scheduling date pickers, slots, and comments to construct an appointment.

### 8. Intake Form Module (AI/Smart Advocate Finder)
- **Path**: `lib/app/modules/intake_form/`
- **Controller**: [intake_form_controller.dart](file:///c:/Users/mdasi/StudioProjects/jurislaw/lib/app/modules/intake_form/controllers/intake_form_controller.dart)
- **View Files**: `views/intake_form_view.dart`, `views/intake_form_mobile.dart`
- **Flow**: 5-step detailed form collecting information on legal problem categories, geographic locations, descriptive parameters, urgency priority, and budget restrictions. Matches and links users to the best advocates.

### 9. Profile & Settings Modules
- **Profile Path**: `lib/app/modules/profile/`
  - Allows logging out via `LocalStorage.signOut()` and accessing child modules.
- **Update Profile Path**: `lib/app/modules/update_profile/`
  - For changing name, email, location, biography, and image.
- **Settings Path**: `lib/app/modules/settings/`
  - Holds toggles for notifications, system theme, and redirects to sub-features.
- **Change Password Path**: `lib/app/modules/settings/change_password/`
  - Modifies authentication password details.
- **2FA Path**: `lib/app/modules/settings/twofa_security/`
  - Handles two-factor SMS/OTP settings.
