import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lawyer_list/data/models/advocate_model.dart';
import '../../../lawyer_list/data/repositories/advocate_repository.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/home_repository.dart';

/// GET /dashboard — invalidate after anything that changes a booking.
final dashboardProvider = FutureProvider<DashboardModel>((ref) {
  return ref.read(homeRepositoryProvider).fetchDashboard();
});

/// First page of the directory in "recommended" order, for the home feed.
final recommendedAdvocatesProvider = FutureProvider<List<AdvocateSummary>>((ref) async {
  final page = await ref.read(advocateRepositoryProvider).fetchAdvocates(const AdvocateQuery());
  return page.items.take(6).toList();
});
