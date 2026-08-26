import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/custom_bottom_nav.dart';
import '../../../../routes/route_names.dart';
import '../controllers/main_shell_controller.dart';
import '../widgets/shell_tab_body.dart';
import '../widgets/shell_navigation_item.dart';

class MainShellMobileView extends ConsumerWidget {
  const MainShellMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainShellControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ShellTabBody(selectedIndex: selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.intakeForm),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_comment_rounded, color: AppColors.textWhite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onSelected: (index) => ref.read(mainShellControllerProvider.notifier).selectTab(index),
        indicatorColor: Colors.transparent,
        destinations: [
          for (final item in shellNavItemsFor(l10n))
            NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}
