import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/bd_locations.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/state/paged_list_state.dart';
import '../../data/models/advocate_model.dart';
import '../../data/repositories/advocate_repository.dart';

/// The directory's current search/sort/filter. Kept separate from the
/// list so the home screen's search card can set it before switching to
/// the Lawyers tab.
class AdvocateQueryController extends Notifier<AdvocateQuery> {
  @override
  AdvocateQuery build() => const AdvocateQuery();

  void set(AdvocateQuery query) => state = query;
  void setSearch(String q) => state = state.copyWith(q: q);
  void setSort(String sort) => state = state.copyWith(sort: sort);
  void reset() => state = AdvocateQuery(sort: state.sort);
}

final advocateQueryProvider = NotifierProvider<AdvocateQueryController, AdvocateQuery>(AdvocateQueryController.new);

/// GET /advocates, re-fetched from page 1 whenever the query changes.
class AdvocateDirectoryController extends PagedListNotifier<AdvocateSummary> {
  @override
  PagedListState<AdvocateSummary> build() {
    ref.listen(advocateQueryProvider, (_, _) => refresh());
    return initialLoad();
  }

  @override
  Future<PaginatedResponse<AdvocateSummary>> fetchPage(int page) =>
      ref.read(advocateRepositoryProvider).fetchAdvocates(ref.read(advocateQueryProvider), page: page);
}

final advocateDirectoryProvider =
    NotifierProvider<AdvocateDirectoryController, PagedListState<AdvocateSummary>>(AdvocateDirectoryController.new);

/// GET /advocates/filters. Falls back to the static division/district list
/// if the call fails, so the filter sheet always has something to show.
final advocateFiltersProvider = FutureProvider<AdvocateFilters>((ref) async {
  try {
    return await ref.read(advocateRepositoryProvider).fetchFilters();
  } catch (_) {
    return AdvocateFilters(
      divisions: BdLocations.divisions,
      districtsByDivision: BdLocations.districtsByDivision,
      districts: BdLocations.districtsByDivision.values.expand((e) => e).toList()..sort(),
    );
  }
});
