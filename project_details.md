# Jurisheba - Project Details

Jurisheba (`my_structure`) is a feature-rich Flutter mobile application designed for legal services and advocate bookings in Bangladesh. It provides local and remote legal support, connecting users with qualified advocates and lawyers for specialized legal consultations.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev) (SDK `^3.9.2`)
- **State Management & Routing**: [GetX](https://pub.dev/packages/get) (`^4.6.5`)
- **Local Storage**: [GetStorage](https://pub.dev/packages/get_storage) (`^2.1.1`) — Used for theme preferences, authentication state, tokens, localization, and user profile cache.
- **HTTP Client**: [http](https://pub.dev/packages/http) (`^1.2.0`)
- **Logging**: [logger](https://pub.dev/packages/logger) (`^2.4.0`)
- **Internationalization & Localization**: GetX translations with support for **Bangla (bn)** and **English (en)**.
- **Fonts**: [Google Fonts (Inter)](https://pub.dev/packages/google_fonts) (`^6.2.1`)
- **Key UI Packages**:
  - `pinput` (6.0.2) - For OTP verification fields.
  - `table_calendar` (3.2.0) - For scheduling lawyer consult slots.
  - `cached_network_image` - Safe network image loader.
  - `flutter_svg` - SVG rendering for icons.
  - `url_launcher` - For dialing numbers, opening web portals, etc.
  - `image_picker` - For profile picture and legal document attachments.

---

## 📂 Architecture & Directory Structure

The project follows a modified Clean Architecture pattern with an active **Feature-First / Module-First** structure.

```
lib/
├── main.dart                      # App entrypoint (initializes storage, localization, routes)
├── app_initial.dart               # Additional initialization tasks
└── app/
    ├── core/                      # Global singletons, theme, styles, utils, services
    │   ├── constants/             # Global configurations (colors, strings, sizes)
    │   ├── theme/                 # Dark/Light Material App themes
    │   ├── utils/                 # General helpers (e.g., responsive_helper.dart)
    │   ├── localization/          # System translations (translations.dart)
    │   └── services/              # Base services (api_service.dart, local_storage_service.dart, firebase_service.dart)
    ├── data/                      # Backend APIs, Models, Data Repositories
    │   └── models/                # JSON Parsers / Data Classes (e.g., lawyer_model.dart)
    ├── routes/                    # GetX route paths & configuration pages
    │   ├── app_pages.dart         # Registering GetPage elements, transitions & bindings
    │   └── app_routes.dart        # Abstract definition of route names
    ├── widgets/                   # Reusable shared UI widgets (Primary buttons, textfields, appbars, chips)
    └── modules/                   # Independent modules (features) matching each page/flow
```

---

## 📱 Feature & Screen Details

Every feature module in the `lib/app/modules/` directory uses a responsive structure divided as follows:
- **`bindings/`**: Links the module's controller dependency lazy-loading.
- **`controllers/`**: Handles the reactive state variables and business logic.
- **`views/`**: Contains the layout files:
  - `*_view.dart`: Main entrypoint. Detects screen size and dispatches to mobile/tablet/desktop.
  - `*_mobile.dart`: Mobile-optimized user interface.
  - `*_tablet.dart`: Tablet-optimized layout.
  - `*_desktop.dart`: Desktop-optimized layout.
- **`widgets/`**: Private UI components exclusive to the module.

Here is the detailed breakdown of every screen:

### 1. Splash Screen (`/splash`)
- **Purpose**: Displays the logo and boots up the app logic.
- **Flow**: Starts a 2-second timer. Resolves redirection route via `LocalStorage`:
  - If user is logged in -> navigates to `/bottom_nav`
  - If language is not set -> navigates to `/language_selection`
  - If onboard is done -> navigates to `/login`
  - Else -> navigates to `/onboard`
- **UI/UX**: SingleTickerProviderStateMixin handles a scale transition (elastic out) and a fade-in of the central bolt icon logo.

### 2. Language Selection Screen (`/language_selection`)
- **Purpose**: First-time user setup for setting language configuration.
- **Options**: Bangla (বাংলা) and English (English).
- **Behavior**: Saves locale to `LocalStorage.saveLanguage` which updates the GetX locale. Automatically routes to onboarding upon choice.

### 3. Onboarding Screen (`/onboard`)
- **Purpose**: Educational slide tour of the system.
- **Steps**:
  1. *Legal Help at Hand* (⚖️) - Connect with top lawyers across Bangladesh instantly.
  2. *Book Consultations* (📅) - Schedule video, audio, or chat sessions with ease.
  3. *Secure Payments* (💳) - Pay via bKash, Nagad, or Cards securely.
- **Features**: Horizontal swipe using `PageView`, dot-indicator animation, skip option, and a dynamic button that transforms from "Next" to "Get Started".

### 4. Authentication Screens
#### A. Login Screen (`/login`)
- **Purpose**: Phone number authentication.
- **Features**: Phone input field, sends a mock/actual 4-digit code. Uses `pinput` for standard OTP input verification. Includes countdown and resend options.
#### B. Registration Screen (`/register`)
- **Purpose**: User account creation.
- **Form Fields**: Full name, Phone number, Email address, District/City selection (Dropdown), Gender (Male / Female).
- **State**: Validates mandatory inputs, commits user profile cache to `LocalStorage`, and directs to home.

### 5. Main Dashboard Host (`/bottom_nav`)
- **Purpose**: Holds the persistent layout shell with bottom navigation tab selection.
- **Tabs**:
  1. **Home**: Quick actions, categories, and top advocates list.
  2. **Bookings**: Lists all appointments (upcoming, past, completed status).
  3. **Search / Finder**: Interactive searching filter for advocates.
  4. **Profile**: Settings panel and account control directory.

### 6. Home Module (`/home`)
- **Purpose**: User dashboard launcher.
- **Sections**:
  - Greeting card indicating user name.
  - Search bar query launcher.
  - Scrollable Horizontal Category Selector: Family (পারিবারিক), Criminal (ফৌজদারি), Personal (ব্যক্তিগত), Divorce (ডিভোর্স), Land (ভূমি), Tax (ট্যাক্স).
  - Advocate showcase lists: "Nearby You" and "Top Rated" list view displaying fee, location, and rating.

### 7. Advocate / Lawyer Details Screen (`/lawyer_details`)
- **Purpose**: In-depth profile of a single advocate.
- **Sections**:
  - Header: Profile Photo, Name, Designation, Location, Bar Enrollment details, Experience.
  - Stats: Success rate percentage, ratings average, reviews count.
  - Bio: Paragraph details, Education & qualification degrees.
  - Consultation types: Virtual Consultation (Video Call, Audio Call, Chat) or Physical Meeting.
  - Appointment Booking parameters:
    - Date Calendar.
    - Slot Selector list.
    - Text field for problem description.
    - Optional document/file attachment widget.
    - Preview / Proceed to Payment trigger.

### 8. Intake Form Module (`/intake_form`)
- **Purpose**: Step-by-step smart wizard to match user legal requirements with the right advocate.
- **Multi-step Layout**:
  - **Step 1: Problem Category**: Select from 12+ categories (Family Law, Divorce, Child Custody, Property, Criminal, Tax, etc.).
  - **Step 2: Location Selector**: Nested dropdowns for Division and District.
  - **Step 3: Problem Description**: Detailed text area to type issues.
  - **Step 4: Emergency Flag**: A rapid toggle for urgent assistance (Bail, Arrest, Domestic Violence) prioritizing processing.
  - **Step 5: Additional Preferences**: Preferred consult method (Video, Audio, Chat), preferred advocate gender, budget range, and documentation uploading.

### 9. Profile and User Settings (`/profile`, `/update_profile`)
- **Purpose**: Edit and review personal parameters.
- **Features**: Update avatar, full name, phone number, location address, and short biography. Stores variables in `LocalStorage`.

### 10. Settings & Security
#### A. General Settings Screen (`/settings`)
- **Purpose**: System customization.
- **Control Items**: Dark mode switch (re-themes GetX instantly), push notification status, language switcher (updates translation engine), and support panels.
#### B. Change Password (`/settings/change_password`)
- **Purpose**: Change login credentials securely.
- **Fields**: Old Password, New Password, Confirm New Password.
#### C. Two-Factor Security (`/settings/twofa_security`)
- **Purpose**: Configure account lock safeguards.
- **Features**: Enable/Disable 2FA, configure authenticator apps, or configure SMS verification steps.
