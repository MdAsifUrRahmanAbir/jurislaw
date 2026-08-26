// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'উকিল চাই';

  @override
  String get next => 'পরবর্তী';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get back => 'পিছনে';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get continueLabel => 'চালিয়ে যান';

  @override
  String get cancel => 'বাতিল';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get logOut => 'লগ আউট';

  @override
  String get selectLanguageTitle => 'Select Language / ভাষা নির্বাচন করুন';

  @override
  String get selectLanguageSubtitle =>
      'এগিয়ে যেতে আপনার পছন্দের ভাষা বেছে নিন';

  @override
  String get languageBangla => 'Bangla (বাংলা)';

  @override
  String get languageBanglaSubtitle => 'প্রাথমিক ভাষা হিসেবে সেট করা আছে';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishSubtitle => 'ইংরেজি ভাষায় চালিয়ে যান';

  @override
  String get onboard1Title => 'আইনি সহায়তা এখন হাতের নাগালে';

  @override
  String get onboard1Subtitle =>
      'সারা বাংলাদেশের সেরা আইনজীবীদের সাথে তাৎক্ষণিক যোগাযোগ করুন।';

  @override
  String get onboard2Title => 'পরামর্শের জন্য বুক করুন';

  @override
  String get onboard2Subtitle =>
      'ভিডিও, অডিও বা চ্যাট সেশন সহজেই নির্ধারণ করুন।';

  @override
  String get onboard3Title => 'নিরাপদ পেমেন্ট';

  @override
  String get onboard3Subtitle =>
      'বিকাশ, নগদ বা কার্ডের মাধ্যমে নিরাপদে পেমেন্ট করুন।';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get signInPhoneSubtitle => 'আপনার ফোন নম্বর দিয়ে সাইন ইন করুন';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get phoneNumberHint => '০১XXXXXXXXX';

  @override
  String get phoneRequired => 'ফোন নম্বর আবশ্যক';

  @override
  String get phoneInvalid => 'সঠিক ফোন নম্বর দিন';

  @override
  String get sendOtp => 'ওটিপি পাঠান';

  @override
  String get dontHaveAccount =>
      'নতুন এখানে? আপনার নম্বর যাচাই করলেই স্বয়ংক্রিয়ভাবে অ্যাকাউন্ট তৈরি হবে।';

  @override
  String get otpTitle => 'আপনার নম্বর যাচাই করুন';

  @override
  String otpSubtitle(String phone) {
    return '$phone নম্বরে পাঠানো ৬-সংখ্যার কোডটি লিখুন';
  }

  @override
  String get otpCode => 'ওটিপি কোড';

  @override
  String get otpHint => '৬-সংখ্যার কোডটি লিখুন';

  @override
  String get otpRequired => 'ওটিপি আবশ্যক';

  @override
  String get otpInvalid => '৬-সংখ্যার কোডটি লিখুন';

  @override
  String get verifyAndLogin => 'যাচাই করুন এবং লগইন করুন';

  @override
  String resendOtpIn(int seconds) {
    return '$seconds সেকেন্ড পর আবার পাঠান';
  }

  @override
  String get resendOtp => 'ওটিপি আবার পাঠান';

  @override
  String get changePhoneNumber => 'ফোন নম্বর পরিবর্তন করুন';

  @override
  String get completeProfileTitle => 'আপনার প্রোফাইল সম্পূর্ণ করুন';

  @override
  String get completeProfileSubtitle => 'শুরু করতে আর কয়েকটি তথ্য দিন';

  @override
  String get fullName => 'পুরো নাম';

  @override
  String get fullNameHint => 'যেমন: জন ডো';

  @override
  String get fullNameRequired => 'পুরো নাম আবশ্যক';

  @override
  String get emailAddress => 'ইমেইল ঠিকানা';

  @override
  String get emailHint => 'যেমন: john@example.com';

  @override
  String get emailRequired => 'ইমেইল আবশ্যক';

  @override
  String get emailInvalid => 'সঠিক ইমেইল দিন';

  @override
  String get addressInformation => 'ঠিকানার তথ্য';

  @override
  String get division => 'বিভাগ';

  @override
  String get selectDivision => 'বিভাগ নির্বাচন করুন';

  @override
  String get district => 'জেলা';

  @override
  String get selectDistrict => 'জেলা নির্বাচন করুন';

  @override
  String get upazila => 'উপজেলা / থানা';

  @override
  String get selectUpazila => 'উপজেলা / থানা নির্বাচন করুন';

  @override
  String get villageMohalla => 'গ্রাম / মহল্লা';

  @override
  String get villageMohallaHint => 'যেমন: ধানমন্ডি ৩২';

  @override
  String fieldRequired(String field) {
    return '$field আবশ্যক';
  }

  @override
  String get changePhoto => 'ছবি পরিবর্তন করুন';

  @override
  String get completeProfile => 'প্রোফাইল সম্পূর্ণ করুন';

  @override
  String get selectProfilePicture => 'একটি প্রোফাইল ছবি নির্বাচন করুন';

  @override
  String get navHome => 'হোম';

  @override
  String get navLawyers => 'আইনজীবী';

  @override
  String get navBookings => 'বুকিং';

  @override
  String get navProfile => 'প্রোফাইল';
}
