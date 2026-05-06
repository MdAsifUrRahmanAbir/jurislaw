import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_structure/app/core/model/common_message_model.dart';
import 'package:my_structure/app/core/services/api_endpoint.dart';
import 'package:my_structure/app/core/services/api_service.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/core/services/app_snackbar.dart';
import 'package:my_structure/app/routes/app_pages.dart';

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  // Basic Info
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  
  // Address Info
  final selectedDivision = RxnString();
  final selectedDistrict = RxnString();
  final selectedUpazila = RxnString();
  final villageCtrl = TextEditingController();

  // Profile Picture
  final Rxn<File> profileImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  final isLoading = false.obs;

  // Dummy data for dropdowns (Ideally these should come from an API)
  final List<String> divisions = ['Dhaka', 'Chattogram', 'Rajshahi', 'Khulna', 'Barishal', 'Sylhet', 'Rangpur', 'Mymensingh'];
  final List<String> districts = ['Dhaka', 'Gazipur', 'Narayanganj', 'Tangail', 'Faridpur'];
  final List<String> upazilas = ['Savar', 'Dhamrai', 'Kaliakair', 'Sreepur'];

  @override
  void onInit() {
    super.onInit();
    // Pre-fill phone and name if available from local storage
    nameCtrl.text = LocalStorage.getName() ?? '';
    // phone is usually not editable here if it was verified in the previous step
  }

  String? validateName(String? v) {
    if (v == null || v.isEmpty) return 'Full name is required';
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(v)) return 'Enter a valid email';
    return null;
  }

  String? validateRequired(String? v, String fieldName) {
    if (v == null || v.isEmpty) return '$fieldName is required';
    return null;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      AppSnackBar.error('Failed to pick image: $e');
    }
  }

  Future<void> completeProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    if (profileImage.value == null) {
      AppSnackBar.error('Please select a profile picture');
      return;
    }

    isLoading.value = true;
    update();

    try {
      // Prepare multi-part request if there's an image
      Map<String, String> body = {
        'name': nameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'division': selectedDivision.value ?? '',
        'district': selectedDistrict.value ?? '',
        'upazila': selectedUpazila.value ?? '',
        'village': villageCtrl.text.trim(),
      };

      final response = await ApiServices.multipart<CommonMessageModel>(
        CommonMessageModel.fromJson,
        ApiEndpoint.completeProfileUrl,
        body,
        fieldList: ['image'],
        pathList: [profileImage.value!.path],
        showSuccessMessage: true,
      );

      if (response != null) {
        await LocalStorage.saveName(name: nameCtrl.text.trim());
        await LocalStorage.saveEmail(email: emailCtrl.text.trim());
        await LocalStorage.setLoggedIn(value: true);
        Get.offAllNamed(Routes.bottomNav);
      }
    } catch (e) {
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    villageCtrl.dispose();
    super.onClose();
  }
}
