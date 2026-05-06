part of 'login_view.dart';

class LoginMobile extends GetView<LoginController> {
  const LoginMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.gapXXLarge),
                
                const LoginBranding(),
                
                const SizedBox(height: AppSizes.gapXXLarge),

                const LoginHeader(),
                
                const SizedBox(height: AppSizes.gapXXLarge),

                const LoginFields(),

                const SizedBox(height: AppSizes.gapXLarge),

                const LoginButton(),

                const SizedBox(height: AppSizes.gapLarge),

                const LoginFooter(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
