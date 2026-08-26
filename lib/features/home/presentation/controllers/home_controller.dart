import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/lawyer_repository.dart';

/// Just the selected category chip — the lawyer list itself lives in
/// [lawyersProvider] (shared with lawyer_list/lawyer_details).
class HomeController extends Notifier<String> {
  @override
  String build() => lawyerCategories.first;

  void selectCategory(String category) => state = category;
}

final homeControllerProvider = NotifierProvider<HomeController, String>(HomeController.new);
