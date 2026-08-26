import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:template_test/routes/route_names.dart';
import 'package:template_test/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:template_test/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:template_test/features/language_selection/presentation/screens/language_selection_screen.dart';
import 'package:template_test/features/login/presentation/screens/login_screen.dart';
import 'package:template_test/features/otp_verification/presentation/screens/otp_verification_screen.dart';
import 'package:template_test/features/register/presentation/screens/register_screen.dart';
import 'package:template_test/features/main_shell/presentation/screens/main_shell_screen.dart';
import 'package:template_test/features/home/presentation/screens/home_screen.dart';
import 'package:template_test/features/search/presentation/screens/search_screen.dart';
import 'package:template_test/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:template_test/features/profile/presentation/screens/profile_screen.dart';
import 'package:template_test/features/settings/presentation/screens/settings_screen.dart';
import 'package:template_test/features/system/presentation/screens/not_found_screen.dart';
import 'package:template_test/features/system/presentation/screens/error_screen.dart';
import 'package:template_test/features/system/presentation/screens/no_internet_screen.dart';
import 'package:template_test/features/system/presentation/screens/maintenance_screen.dart';
import 'package:template_test/features/change_password/presentation/screens/change_password_screen.dart';
import 'package:template_test/features/help_support/presentation/screens/help_support_screen.dart';
import 'package:template_test/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:template_test/features/intake_form/presentation/screens/intake_form_screen.dart';
import 'package:template_test/features/lawyer_list/presentation/screens/lawyer_list_screen.dart';
import 'package:template_test/features/lawyer_details/presentation/screens/lawyer_details_screen.dart';
import 'package:template_test/features/home/data/models/lawyer_model.dart';
import 'package:template_test/features/twofa_security/presentation/screens/twofa_security_screen.dart';

import '../core/network/connectivity_provider.dart';
import '../core/observers/logging_observer.dart';
import '../core/session/auth_session_controller.dart';
import '../core/session/auth_session_state.dart';
import '../features/edit_profile/presentation/screens/edit_profile_screen.dart';
import '../features/terms_privacy/presentation/screens/terms_privacy_screen.dart';

final hasCompletedInitialNavigationProvider = StateProvider<bool>((ref) => false);

/// Routes reachable while logged out (or before session status is known).
/// Everything else redirects to login once we know the user is unauthenticated.
const _publicRoutes = {
  RouteNames.splash,
  RouteNames.languageSelection,
  RouteNames.onboarding,
  RouteNames.login,
  RouteNames.otpVerification,
  RouteNames.register,
  RouteNames.noInternet,
  RouteNames.maintenance,
  RouteNames.notFound,
  RouteNames.error,
};

final routerProvider = Provider<GoRouter>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    errorBuilder: (context, state) => const NotFoundScreen(),
    observers: [LoggingObserver()],
    refreshListenable: GoRouterRefreshStream(connectivityService.onStatusChange),

    redirect: (context, state) {
      if (state.matchedLocation == RouteNames.splash) return null;

      if (!ref.read(hasCompletedInitialNavigationProvider)) {
        ref.read(hasCompletedInitialNavigationProvider.notifier).state = true;
        return null;
      }

      final isConnected = ref.read(connectivityServiceProvider).isConnected;
      final offlineModeEnabled = ref.read(offlineModeProvider);
      final onNoInternetRoute = state.matchedLocation == RouteNames.noInternet;

      if (!isConnected && !offlineModeEnabled) {
        return onNoInternetRoute ? null : RouteNames.noInternet;
      }

      if (isConnected && offlineModeEnabled) {
        ref.read(offlineModeProvider.notifier).disable();
      }

      final authStatus = ref.read(authSessionControllerProvider).status;
      if (authStatus == AuthStatus.unauthenticated && !_publicRoutes.contains(state.matchedLocation)) {
        return RouteNames.login;
      }

      return null;
    },

    routes: [
      GoRoute(path: RouteNames.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: RouteNames.languageSelection,
        builder: (_, _) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(path: RouteNames.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: RouteNames.otpVerification,
        builder: (_, state) => OtpVerificationScreen(phone: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.mainShell,
        builder: (_, _) => const MainShellScreen(),
      ),
      GoRoute(path: RouteNames.home, builder: (_, _) => const HomeScreen()),
      GoRoute(path: RouteNames.search, builder: (_, _) => const SearchScreen()),
      GoRoute(
        path: RouteNames.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.notFound,
        builder: (_, _) => const NotFoundScreen(),
      ),
      GoRoute(path: RouteNames.error, builder: (_, _) => const ErrorScreen()),
      GoRoute(
        path: RouteNames.noInternet,
        builder: (_, _) => const NoInternetScreen(),
      ),
      GoRoute(
        path: RouteNames.maintenance,
        builder: (_, _) => const MaintenanceScreen(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.helpSupport,
        builder: (_, _) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.termsPrivacy,
        builder: (context, state) => const TermsPrivacyScreen(),
      ),
      GoRoute(
        path: RouteNames.bookings,
        builder: (_, _) => const BookingsScreen(),
      ),
      GoRoute(
        path: RouteNames.intakeForm,
        builder: (_, _) => const IntakeFormScreen(),
      ),
      GoRoute(
        path: RouteNames.lawyerList,
        builder: (_, _) => const LawyerListScreen(),
      ),
      GoRoute(
        path: RouteNames.lawyerDetails,
        builder: (_, state) => LawyerDetailsScreen(lawyer: state.extra as Lawyer),
      ),
      GoRoute(
        path: RouteNames.twofaSecurity,
        builder: (_, _) => const TwofaSecurityScreen(),
      ),
    ],
  );
});
