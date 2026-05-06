part of 'registration_view.dart';

class RegistrationMobile extends GetView<RegistrationController> {
  const RegistrationMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Form(
            key: controller.formKey,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSizes.gapXXLarge),

                RegistrationHeader(),

                SizedBox(height: AppSizes.gapXXLarge),

                RegistrationFields(),

                SizedBox(height: AppSizes.gapXXLarge),

                RegistrationAddressInfo(),

                SizedBox(height: AppSizes.gapXXLarge),

                RegistrationProfilePic(),

                SizedBox(height: AppSizes.gapXXLarge),

                RegistrationButton(),

                SizedBox(height: AppSizes.gapLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
