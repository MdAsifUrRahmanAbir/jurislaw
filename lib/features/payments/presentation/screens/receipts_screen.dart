import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/state/paged_list_state.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/status_badge.dart';
import '../../../../core/widgets/utility/empty_state.dart';
import '../../../../core/widgets/utility/paged_list_view.dart';
import '../../../../routes/route_names.dart';
import '../../data/models/payment_models.dart';
import '../../data/repositories/payment_repository.dart';

class ReceiptsController extends PagedListNotifier<PaymentReceipt> {
  @override
  PagedListState<PaymentReceipt> build() => initialLoad();

  @override
  Future<PaginatedResponse<PaymentReceipt>> fetchPage(int page) =>
      ref.read(paymentRepositoryProvider).fetchReceipts(page: page);
}

final receiptsControllerProvider =
    NotifierProvider.autoDispose<ReceiptsController, PagedListState<PaymentReceipt>>(ReceiptsController.new);

/// My receipts (A6.4) — newest first.
class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(receiptsControllerProvider);
    final controller = ref.read(receiptsControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Payment History'),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: PagedListView<PaymentReceipt>(
                    state: state,
                    onRefresh: controller.refresh,
                    onLoadMore: controller.loadMore,
                    onRetryMore: controller.retryMore,
                    empty: const EmptyState(
                      title: 'No payments yet',
                      message: 'Receipts for your consultations will appear here.',
                      icon: Icons.receipt_long_outlined,
                    ),
                    itemBuilder: (context, receipt, _) => _ReceiptTile(
                      receipt: receipt,
                      onTap: receipt.bookingId == null ? null : () => context.push(RouteNames.bookingDetailsPath(receipt.bookingId!)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  final PaymentReceipt receipt;
  final VoidCallback? onTap;

  const _ReceiptTile({required this.receipt, this.onTap});

  StatusBadgeType get _type => switch (receipt.status) {
        'paid' || 'success' || 'completed' => StatusBadgeType.success,
        'pending' => StatusBadgeType.warning,
        'refunded' => StatusBadgeType.info,
        _ => StatusBadgeType.error,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final statusText = receipt.status.isEmpty ? '' : receipt.status[0].toUpperCase() + receipt.status.substring(1);

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receipt.advocateName.isEmpty ? 'Consultation payment' : receipt.advocateName,
                  style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (receipt.paidAt != null) DateFormatter.dayTime(receipt.paidAt!),
                    if (receipt.method != null) receipt.method!,
                  ].join(' · '),
                  style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textSecondary),
                ),
                Text(receipt.transactionId, style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textHint)),
                if (receipt.refundStatus != null) ...[
                  const SizedBox(height: AppSizes.xs),
                  StatusBadge(text: 'Refund ${receipt.refundStatus}', type: StatusBadgeType.info, compact: true, shape: StatusBadgeShape.square),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(CurrencyFormatter.taka(receipt.total), style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary)),
              const SizedBox(height: AppSizes.xs),
              if (statusText.isNotEmpty) StatusBadge(text: statusText, type: _type, compact: true, shape: StatusBadgeShape.square),
            ],
          ),
        ],
      ),
    );
  }
}
