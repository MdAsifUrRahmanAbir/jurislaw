import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../../onboarding/onboarding_screen.dart';
import '../modules/language_selection/bindings/language_selection_binding.dart';
import '../modules/language_selection/views/language_selection_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/registration/bindings/registration_binding.dart';
import '../modules/auth/registration/views/registration_view.dart';
import '../modules/bottom_nav/bindings/bottom_nav_binding.dart';
import '../modules/bottom_nav/views/bottom_nav_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/change_password/bindings/change_password_binding.dart';
import '../modules/settings/change_password/views/change_password_view.dart';
import '../modules/settings/twofa_security/bindings/twofa_security_binding.dart';
import '../modules/settings/twofa_security/views/twofa_security_view.dart';
import '../modules/lawyer_details/bindings/lawyer_details_binding.dart';
import '../modules/lawyer_details/views/lawyer_details_view.dart';
import '../modules/intake_form/bindings/intake_form_binding.dart';
import '../modules/intake_form/views/intake_form_view.dart';

part 'app_routes.dart';

/// GetX route configuration — all pages registered here.
class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    // ... existed ...
    GetPage(
      name: Routes.intakeForm,
      page: () => const IntakeFormView(),
      binding: IntakeFormBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.onboard,
      page: () => const OnboardingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.languageSelection,
      page: () => const LanguageSelectionView(),
      binding: LanguageSelectionBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.bottomNav,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.updateProfile,
      page: () => const UpdateProfileView(),
      binding: UpdateProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.twofaSecurity,
      page: () => const TwofaSecurityView(),
      binding: TwofaSecurityBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.lawyerDetails,
      page: () => const LawyerDetailsView(),
      binding: LawyerDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
