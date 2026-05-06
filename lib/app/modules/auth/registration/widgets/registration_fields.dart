part of '../views/registration_view.dart';

class RegistrationFields extends GetView<RegistrationController> {
  const RegistrationFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PrimaryInputField(
            label: 'Full Name',
            hint: 'e.g. John Doe',
            controller: controller.nameCtrl,
            validator: controller.validateName,
            isRequired: true,
          ),
        ),
        const SizedBox(width: AppSizes.gapMid),
        Expanded(
          child: PrimaryInputField(
            label: 'Email Address',
            hint: 'e.g. john@example.com',
            controller: controller.emailCtrl,
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
          ),
        ),
      ],
    );
  }
}
