import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/lawyer_card.dart';
import '../controllers/lawyer_list_controller.dart';

class LawyerListView extends GetView<LawyerListController> {
  const LawyerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Find Advocates', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: AppColors.gold),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMid),
            color: AppColors.primary,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or specialty...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (val) {
                // Implement search logic if needed
              },
            ),
          ),
          
          // Filter Chips Row
          _buildActiveFilters(),

          // Result List
          Expanded(
            child: Obx(() {
              if (controller.filteredLawyers.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppSizes.paddingMid),
                itemCount: controller.filteredLawyers.length,
                itemBuilder: (context, index) {
                  final lawyer = controller.filteredLawyers[index];
                  return LawyerCard(lawyer: lawyer);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Obx(() {
      final hasFilters = controller.selectedArea.value != 'All' || 
                         controller.selectedLocation.value != 'All' || 
                         controller.minExperience.value > 0;
      
      if (!hasFilters) return const SizedBox.shrink();

      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (controller.selectedArea.value != 'All')
              _FilterChip(label: controller.selectedArea.value, onClear: () => controller.selectedArea.value = 'All'),
            if (controller.selectedLocation.value != 'All')
              _FilterChip(label: controller.selectedLocation.value, onClear: () => controller.selectedLocation.value = 'All'),
            if (controller.minExperience.value > 0)
              _FilterChip(label: '${controller.minExperience.value}+ Years', onClear: () => controller.minExperience.value = 0),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No advocates found matching your filters.', style: TextStyle(color: AppColors.textSecondary)),
          TextButton(
            onPressed: controller.resetFilters,
            child: const Text('Reset All Filters', style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text('Advanced Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Practice Area', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(() => Wrap(
                spacing: 8,
                children: controller.areas.map((area) => ChoiceChip(
                  label: Text(area),
                  selected: controller.selectedArea.value == area,
                  onSelected: (val) => controller.selectedArea.value = area,
                  selectedColor: AppColors.gold.withOpacity(0.2),
                  labelStyle: TextStyle(color: controller.selectedArea.value == area ? AppColors.gold : Colors.black),
                )).toList(),
              )),

              const SizedBox(height: 24),
              const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(() => Wrap(
                spacing: 8,
                children: controller.locations.map((loc) => ChoiceChip(
                  label: Text(loc),
                  selected: controller.selectedLocation.value == loc,
                  onSelected: (val) => controller.selectedLocation.value = loc,
                  selectedColor: AppColors.gold.withOpacity(0.2),
                )).toList(),
              )),

              const SizedBox(height: 24),
              const Text('Experience (Years+)', style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Slider(
                value: controller.minExperience.value.toDouble(),
                min: 0, max: 20, divisions: 4,
                activeColor: AppColors.gold,
                label: '${controller.minExperience.value}+ Years',
                onChanged: (val) => controller.minExperience.value = val.toInt(),
              )),

              const SizedBox(height: 24),
              const Text('Max Fee (৳)', style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Slider(
                value: controller.maxFee.value,
                min: 500, max: 10000, divisions: 19,
                activeColor: AppColors.gold,
                label: '৳${controller.maxFee.value.toInt()}',
                onChanged: (val) => controller.maxFee.value = val,
              )),

              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Apply Filters',
                onPressed: () {
                  controller.applyFilters();
                  Get.back();
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    controller.resetFilters();
                    Get.back();
                  },
                  child: const Text('Reset All', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onClear;
  const _FilterChip({required this.label, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, size: 14, color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}
