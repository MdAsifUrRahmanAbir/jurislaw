import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/services/api_endpoint.dart';
import 'package:my_structure/app/core/services/api_service.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/core/services/app_snackbar.dart';
import 'package:my_structure/app/routes/app_pages.dart';
import '../../models/send_otp_model.dart';
import '../../models/verify_otp_model.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  final isOtpSent = false.obs;
  // final isLoading = false.obs;

  // Timer for Resend OTP
  Timer? _timer;
  final resendSeconds = 60.obs;
  final canResend = false.obs;

  void startResendTimer() {
    canResend.value = false;
    resendSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Phone number is required';
    if (v.length < 10) return 'Enter a valid phone number';
    return null;
  }

  String? validateOtp(String? v) {
    if (v == null || v.isEmpty) return 'OTP is required';
    if (v.length < 4) return 'Enter 4 digit OTP';
    return null;
  }

  /// ---- SendOtp API
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  SendOtpModel get sendOtpModel => _sendOtpModel;
  late SendOtpModel _sendOtpModel ;

  Future<SendOtpModel?> sendOtp() async {
    if (!formKey.currentState!.validate()) return null;
    _isLoading.value = true;
    update();

    try {
      final response = await ApiServices.post<SendOtpModel>(
        SendOtpModel.fromJson,
        ApiEndpoint.sendOtpUrl,
        body: {'phone': phoneCtrl.text.trim()},
        showSuccessMessage: true,
        isBasic: true,
      );

      if (response != null) {
        _sendOtpModel = response;
        isOtpSent.value = true;
        startResendTimer();
      }
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      _isLoading.value = false;
      update();
    }
    return null;
  }

  /// ---- SendOtp API
  final _isVerifyLoading = false.obs;
  bool get isVerifyLoading => _isVerifyLoading.value;

  VerifyOtpModel get verifyOtpModel => _verifyOtpModel;
  late VerifyOtpModel _verifyOtpModel ;

  Future<void> verifyOtp() async {
    if (!formKey.currentState!.validate()) return;
    _isVerifyLoading.value = true;
    update();

    try {
      final response = await ApiServices.post<VerifyOtpModel>(
        VerifyOtpModel.fromJson,
        ApiEndpoint.verifyOtpUrl,
        body: {
          'phone': phoneCtrl.text.trim(),
          'otp': otpCtrl.text.trim(),
        },
        showSuccessMessage: true,
        isBasic: true,
      );

      if (response != null) {
        // Save user info and token
        await LocalStorage.saveToken(token: response.data.token);
        await LocalStorage.savePhone(phone: response.data.user.phone);
        await LocalStorage.saveName(name: response.data.user.name);
        await LocalStorage.saveEmail(email: response.data.user.email);
        await LocalStorage.saveImage(url: response.data.user.profilePhoto);


        // Check if profile is complete and navigate accordingly
        if (response.data.isProfileComplete) {
          await LocalStorage.setLoggedIn(value: true);
          Get.offAllNamed(Routes.bottomNav);
        } else {
          // If profile is not complete, you might want to navigate to a complete profile screen
          // For now, navigating to bottomNav as a fallback
          Get.toNamed(Routes.register);
        }
      }
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      _isVerifyLoading.value = false;
      update();
    }
  }

  void resendOtp() {
    if (canResend.value) {
      sendOtp();
    }
  }

  void goToRegister() => Get.toNamed(Routes.register);

  @override
  void onClose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
