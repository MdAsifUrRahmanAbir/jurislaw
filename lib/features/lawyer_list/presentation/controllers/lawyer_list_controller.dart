import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/data/models/lawyer_model.dart';
import '../../../home/data/repositories/lawyer_repository.dart';
import '../states/lawyer_list_state.dart';

const lawyerAreas = ['All', 'Family', 'Criminal', 'Land', 'Divorce', 'Business', 'Tax', 'Labor Law', 'Writ'];
const lawyerLocations = ['All', 'Dhaka', 'Chattogram', 'Sylhet', 'Rajshahi'];

class LawyerFilterController extends Notifier<LawyerFilterState> {
  @override
  LawyerFilterState build() => const LawyerFilterState();

  void setArea(String value) => state = state.copyWith(area: value);
  void setLocation(String value) => state = state.copyWith(location: value);
  void setMinExperience(int value) => state = state.copyWith(minExperience: value);
  void setMaxFee(double value) => state = state.copyWith(maxFee: value);
  void reset() => state = const LawyerFilterState();
}

final lawyerFilterControllerProvider =
    NotifierProvider.autoDispose<LawyerFilterController, LawyerFilterState>(LawyerFilterController.new);

final filteredLawyersProvider = Provider.autoDispose<List<Lawyer>>((ref) {
  final all = ref.watch(lawyersProvider);
  final filter = ref.watch(lawyerFilterControllerProvider);

  return all.where((lawyer) {
    final matchArea = filter.area == 'All' || lawyer.practiceAreas.contains(filter.area) || lawyer.specialty.contains(filter.area);
    final matchLoc = filter.location == 'All' || lawyer.location.toLowerCase().contains(filter.location.toLowerCase());
    final matchExp = lawyer.experience >= filter.minExperience;
    final matchRating = lawyer.rating >= filter.minRating;
    final matchFee = lawyer.fee <= filter.maxFee;
    return matchArea && matchLoc && matchExp && matchRating && matchFee;
  }).toList();
});
