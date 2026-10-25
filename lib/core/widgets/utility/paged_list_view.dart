import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../state/paged_list_state.dart';
import 'custom_loader.dart';
import 'empty_state.dart';
import 'error_state.dart';

/// Renders a [PagedListState]: first-load spinner, blocking error with
/// retry, empty state, pull-to-refresh, and a footer that loads the next
/// page when the user scrolls near the end.
class PagedListView<T> extends StatelessWidget {
  final PagedListState<T> state;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final VoidCallback? onRetryMore;
  final Widget empty;
  final EdgeInsetsGeometry padding;
  final Widget? header;
  final double spacing;

  const PagedListView({
    super.key,
    required this.state,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.onRetryMore,
    this.empty = const EmptyState(title: 'Nothing here yet'),
    this.padding = const EdgeInsets.all(AppSizes.md),
    this.header,
    this.spacing = AppSizes.md,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) return const CustomLoader();

    // A filtered view can be empty while more pages exist — keep loading.
    if (state.isEmpty && state.hasMore) {
      if (!state.isLoadingMore) WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
      return const CustomLoader();
    }

    final Widget body;
    if (state.hasBlockingError || state.isEmpty) {
      // Still scrollable so pull-to-refresh works on the empty/error view.
      body = LayoutBuilder(
        builder: (context, constraints) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          children: [
            ?header,
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight * 0.6),
              child: state.hasBlockingError ? ErrorState(message: state.errorMessage!, onRetry: onRefresh) : empty,
            ),
          ],
        ),
      );
    } else {
      // A short page can't be scrolled, so the scroll trigger below would
      // never fire — ask for the next page straight away.
      if (state.hasMore && !state.isLoadingMore && state.errorMessage == null && state.items.length < 6) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onLoadMore());
      }
      final headerCount = header == null ? 0 : 1;
      body = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 400) onLoadMore();
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          itemCount: headerCount + state.items.length + 1,
          itemBuilder: (context, index) {
            if (header != null && index == 0) return header!;
            final i = index - headerCount;
            if (i == state.items.length) return _footer(context);
            return Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: itemBuilder(context, state.items[i], i),
            );
          },
        ),
      );
    }

    return RefreshIndicator(color: AppColors.primary, onRefresh: onRefresh, child: body);
  }

  Widget _footer(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(padding: EdgeInsets.all(AppSizes.md), child: CustomLoader(size: AppSizes.iconMd));
    }
    if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetryMore,
            icon: const Icon(Icons.refresh_rounded),
            label: Text('Couldn\'t load more. Tap to retry.', style: TextStyle(color: AppColors.error.withValues(alpha: 0.9))),
          ),
        ),
      );
    }
    return const SizedBox(height: AppSizes.xl);
  }
}
