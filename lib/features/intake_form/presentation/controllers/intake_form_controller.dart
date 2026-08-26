import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Static option lists ported as-is from ukil-chaai's IntakeFormController —
/// there is no legal-category/area-lookup API in the backend yet.
class IntakeFormOptions {
  IntakeFormOptions._();

  static const categories = [
    'Family Law',
    'Divorce',
    'Child Custody',
    'Property / Land Dispute',
    'Criminal Case',
    'Business / Commercial Law',
    'Labour / Employment Issue',
    'Tax / VAT Issue',
    'Banking / Loan Dispute',
    'Cyber Crime / Digital Fraud',
    'Constitutional / Writ Matter',
    'Others',
  ];

  static const divisions = ['Dhaka', 'Chattogram', 'Sylhet', 'Rajshahi', 'Khulna', 'Barishal', 'Rangpur', 'Mymensingh'];
  static const districts = ['Dhaka', 'Gazipur', 'Narayanganj', 'Uttara', 'Mirpur', 'Gulshan'];
  static const consultationTypes = ['Video Call', 'Audio Call', 'Chat Only', 'In Person'];
  static const languages = ['Bengali', 'English', 'Both'];
  static const genders = ['Any', 'Male', 'Female'];
  static const budgets = ['৳1000 – ৳3000', '৳3000 – ৳5000', '৳5000+'];
}

class IntakeFormState {
  final Set<String> selectedCategories;
  final String? division;
  final String? district;
  final bool isEmergency;
  final String consultationType;
  final String language;
  final String preferredGender;
  final String budget;

  const IntakeFormState({
    this.selectedCategories = const {},
    this.division,
    this.district,
    this.isEmergency = false,
    this.consultationType = 'Video Call',
    this.language = 'Bengali',
    this.preferredGender = 'Any',
    this.budget = '৳1000 – ৳3000',
  });

  IntakeFormState copyWith({
    Set<String>? selectedCategories,
    String? division,
    String? district,
    bool? isEmergency,
    String? consultationType,
    String? language,
    String? preferredGender,
    String? budget,
  }) {
    return IntakeFormState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      division: division ?? this.division,
      district: district ?? this.district,
      isEmergency: isEmergency ?? this.isEmergency,
      consultationType: consultationType ?? this.consultationType,
      language: language ?? this.language,
      preferredGender: preferredGender ?? this.preferredGender,
      budget: budget ?? this.budget,
    );
  }
}

/// Multi-section "describe your legal issue" form. Source's `submitForm()`
/// has no backend call at all (only local validation + a success message),
/// so this stays local-only too — see [submit].
class IntakeFormController extends Notifier<IntakeFormState> {
  late final TextEditingController areaController;
  late final TextEditingController issueDescriptionController;

  @override
  IntakeFormState build() {
    areaController = TextEditingController();
    issueDescriptionController = TextEditingController();
    ref.onDispose(() {
      areaController.dispose();
      issueDescriptionController.dispose();
    });
    return const IntakeFormState();
  }

  void toggleCategory(String category) {
    final next = {...state.selectedCategories};
    if (!next.remove(category)) next.add(category);
    state = state.copyWith(selectedCategories: next);
  }

  void setDivision(String? value) => state = state.copyWith(division: value);
  void setDistrict(String? value) => state = state.copyWith(district: value);
  void setEmergency(bool value) => state = state.copyWith(isEmergency: value);
  void setConsultationType(String value) => state = state.copyWith(consultationType: value);
  void setLanguage(String value) => state = state.copyWith(language: value);
  void setPreferredGender(String value) => state = state.copyWith(preferredGender: value);
  void setBudget(String value) => state = state.copyWith(budget: value);

  bool get isValid => state.selectedCategories.isNotEmpty && issueDescriptionController.text.trim().length >= 10;

  bool submit() => isValid;
}

final intakeFormControllerProvider =
    NotifierProvider.autoDispose<IntakeFormController, IntakeFormState>(IntakeFormController.new);
