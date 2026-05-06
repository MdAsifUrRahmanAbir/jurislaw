part of '../views/registration_view.dart';

class RegistrationButton extends GetView<RegistrationController> {
  const RegistrationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PrimaryButton(
        text: 'Complete Setup',
        isLoading: controller.isLoading.value,
        onPressed: controller.completeProfile,
      ),
    );
  }
}
