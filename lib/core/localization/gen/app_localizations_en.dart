// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ukil Chaai';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get back => 'Back';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueLabel => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get logOut => 'Log Out';

  @override
  String get selectLanguageTitle => 'Select Language / ভাষা নির্বাচন করুন';

  @override
  String get selectLanguageSubtitle =>
      'Choose your preferred language to continue';

  @override
  String get languageBangla => 'Bangla (বাংলা)';

  @override
  String get languageBanglaSubtitle => 'চালিয়ে যেতে বাংলা ভাষা ব্যবহার করুন';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishSubtitle => 'Continue with English language';

  @override
  String get onboard1Title => 'Legal Help at Hand';

  @override
  String get onboard1Subtitle =>
      'Connect with top lawyers across Bangladesh instantly.';

  @override
  String get onboard2Title => 'Book Consultations';

  @override
  String get onboard2Subtitle =>
      'Schedule video, audio or chat sessions with ease.';

  @override
  String get onboard3Title => 'Secure Payments';

  @override
  String get onboard3Subtitle => 'Pay via bKash, Nagad, or Cards securely.';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInPhoneSubtitle => 'Sign in with your phone number';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => '01XXXXXXXXX';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid => 'Enter a valid phone number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get dontHaveAccount =>
      'New here? Verifying your number creates your account automatically.';

  @override
  String get otpTitle => 'Verify Your Number';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the 6-digit code sent to $phone';
  }

  @override
  String get otpCode => 'OTP Code';

  @override
  String get otpHint => 'Enter 6-digit code';

  @override
  String get otpRequired => 'OTP is required';

  @override
  String get otpInvalid => 'Enter the 6-digit code';

  @override
  String get verifyAndLogin => 'Verify & Login';

  @override
  String resendOtpIn(int seconds) {
    return 'Resend OTP in ${seconds}s';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get changePhoneNumber => 'Change Phone Number';

  @override
  String get completeProfileTitle => 'Complete Your Profile';

  @override
  String get completeProfileSubtitle =>
      'Just a few more details to get started';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'e.g. John Doe';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'e.g. john@example.com';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get addressInformation => 'ADDRESS INFORMATION';

  @override
  String get division => 'Division';

  @override
  String get selectDivision => 'Select Division';

  @override
  String get district => 'District';

  @override
  String get selectDistrict => 'Select District';

  @override
  String get upazila => 'Upazila / Thana';

  @override
  String get selectUpazila => 'Select Upazila / Thana';

  @override
  String get villageMohalla => 'Village / Mohalla';

  @override
  String get villageMohallaHint => 'e.g. Dhanmondi 32';

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get completeProfile => 'Complete Profile';

  @override
  String get selectProfilePicture => 'Please select a profile picture';

  @override
  String get navHome => 'Home';

  @override
  String get navLawyers => 'Lawyers';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navProfile => 'Profile';
}
