import '../../../../core/widgets/common/password_strength_meter.dart';

class ChangePasswordState {
  final PasswordStrength passwordStrength;

  const ChangePasswordState({
    this.passwordStrength = PasswordStrength.weak,
  });

  ChangePasswordState copyWith({
    PasswordStrength? passwordStrength,
  }) {
    return ChangePasswordState(
      passwordStrength:
      passwordStrength ?? this.passwordStrength,
    );
  }
}
