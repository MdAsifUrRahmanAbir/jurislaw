import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/paginated_response.dart';
import '../utils/error_mapper.dart';

/// State of an infinitely-scrolling `?page=N` list.
class PagedListState<T> {
  final List<T> items;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final Map<String, dynamic> meta;

  const PagedListState({
    this.items = const [],
    this.page = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.meta = const {},
  });

  /// First load in progress, nothing to show yet.
  bool get isInitialLoading => isLoading && items.isEmpty;

  /// First load failed, nothing to show.
  bool get hasBlockingError => errorMessage != null && items.isEmpty;

  bool get isEmpty => !isLoading && errorMessage == null && items.isEmpty;

  PagedListState<T> copyWith({
    List<T>? items,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    Map<String, dynamic>? meta,
  }) {
    return PagedListState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      meta: meta ?? this.meta,
    );
  }
}

/// Base notifier for paginated lists: subclasses implement [fetchPage];
/// screens call [refresh] (pull-to-refresh / filter change) and
/// [loadMore] (scrolled near the end).
abstract class PagedListNotifier<T> extends Notifier<PagedListState<T>> {
  int _generation = 0;

  Future<PaginatedResponse<T>> fetchPage(int page);

  /// Call from [build] to start the first load.
  PagedListState<T> initialLoad() {
    Future.microtask(refresh);
    return PagedListState<T>(isLoading: true);
  }

  Future<void> refresh() async {
    final generation = ++_generation;
    state = state.copyWith(isLoading: true, isLoadingMore: false, errorMessage: null);
    try {
      final result = await fetchPage(1);
      if (generation != _generation) return;
      state = PagedListState<T>(items: result.items, page: 1, hasMore: result.hasMore, meta: result.meta);
    } catch (e) {
      if (generation != _generation) return;
      state = state.copyWith(isLoading: false, errorMessage: getErrorMessage(e));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore || state.errorMessage != null) return;
    final generation = _generation;
    state = state.copyWith(isLoadingMore: true);
    try {
      final result = await fetchPage(state.page + 1);
      if (generation != _generation) return;
      state = state.copyWith(
        items: [...state.items, ...result.items],
        page: result.currentPage,
        hasMore: result.hasMore && result.items.isNotEmpty,
        isLoadingMore: false,
        meta: result.meta,
      );
    } catch (e) {
      if (generation != _generation) return;
      state = state.copyWith(isLoadingMore: false, errorMessage: getErrorMessage(e));
    }
  }

  /// Retry after a failed [loadMore] without dropping loaded items.
  Future<void> retryMore() async {
    state = state.copyWith(errorMessage: null);
    await loadMore();
  }

  void replaceWhere(bool Function(T item) test, T Function(T item) update) {
    state = state.copyWith(items: [for (final item in state.items) test(item) ? update(item) : item]);
  }
}
