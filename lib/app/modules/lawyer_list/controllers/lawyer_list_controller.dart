import 'package:get/get.dart';
import '../../../data/models/lawyer_model.dart';
import '../../home/controllers/home_controller.dart';

class LawyerListController extends GetxController {
  final allLawyers = <Lawyer>[].obs;
  final filteredLawyers = <Lawyer>[].obs;

  // Filter States
  final selectedArea = 'All'.obs;
  final selectedLocation = 'All'.obs;
  final minExperience = 0.obs;
  final minRating = 0.0.obs;
  final maxFee = 10000.0.obs;

  final areas = ['All', 'Family', 'Criminal', 'Land', 'Divorce', 'Business', 'Tax', 'Labour', 'Writ'];
  final locations = ['All', 'Dhaka', 'Chittagong', 'Sylhet', 'Rajshahi'];

  @override
  void onInit() {
    super.onInit();
    // Get lawyers from HomeController if available, or use dummy
    final homeController = Get.find<HomeController>();
    allLawyers.assignAll(homeController.lawyers);
    applyFilters();
  }

  void applyFilters() {
    filteredLawyers.assignAll(allLawyers.where((lawyer) {
      final matchArea = selectedArea.value == 'All' || 
          lawyer.practiceAreas.contains(selectedArea.value) || 
          lawyer.specialty.contains(selectedArea.value);
      
      final matchLoc = selectedLocation.value == 'All' || 
          lawyer.location.toLowerCase().contains(selectedLocation.value.toLowerCase());
          
      final matchExp = lawyer.experience >= minExperience.value;
      final matchRating = lawyer.rating >= minRating.value;
      final matchFee = lawyer.fee <= maxFee.value;

      return matchArea && matchLoc && matchExp && matchRating && matchFee;
    }).toList());
  }

  void resetFilters() {
    selectedArea.value = 'All';
    selectedLocation.value = 'All';
    minExperience.value = 0;
    minRating.value = 0.0;
    maxFee.value = 10000.0;
    applyFilters();
  }
}
