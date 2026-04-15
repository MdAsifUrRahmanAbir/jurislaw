import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_appbar_widget.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(title: AppStrings.editProfile),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              const SizedBox(height: AppSizes.gapMid),

              // Avatar
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.greyLight,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 56,
                        color: AppColors.grey,
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.gapXLarge),

              // Full name
              PrimaryInputField(
                label: AppStrings.fullName,
                hint: AppStrings.fullNameHint,
                controller: controller.nameCtrl,
                validator: controller.validateName,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppSizes.gapMid),

              // Email
              PrimaryInputField(
                label: AppStrings.email,
                hint: AppStrings.emailHint,
                controller: controller.emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppSizes.gapMid),

              // Phone
              PrimaryInputField(
                label: AppStrings.phoneNumber,
                hint: AppStrings.phoneHint,
                controller: controller.phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppSizes.gapMid),

              // Location
              PrimaryInputField(
                label: AppStrings.location,
                hint: AppStrings.locationHint,
                controller: controller.locationCtrl,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppSizes.gapMid),

              // Bio
              PrimaryInputField(
                label: AppStrings.bio,
                hint: AppStrings.bioHint,
                controller: controller.bioCtrl,
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSizes.gapXLarge),

              // Save button
              Obx(
                () => PrimaryButton(
                  text: AppStrings.saveChanges,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.saveProfile,
                ),
              ),
              const SizedBox(height: AppSizes.gapLarge),
            ],
          ),
        ),
      ),
    );
  }
}
