part of 'lawyer_list_view.dart';

class LawyerListMobile extends GetView<LawyerListController> {
  const LawyerListMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('find_advocates'.tr, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
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
                hintText: 'search_hint'.tr,
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
              FilterChipWidget(label: controller.selectedArea.value == 'All' ? 'all'.tr : controller.selectedArea.value, onClear: () => controller.selectedArea.value = 'All'),
            if (controller.selectedLocation.value != 'All')
              FilterChipWidget(label: controller.selectedLocation.value == 'All' ? 'all'.tr : controller.selectedLocation.value, onClear: () => controller.selectedLocation.value = 'All'),
            if (controller.minExperience.value > 0)
              FilterChipWidget(label: '${controller.minExperience.value}+ ${'years_plus'.tr}', onClear: () => controller.minExperience.value = 0),
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
          Text('no_advocates_found'.tr, style: const TextStyle(color: AppColors.textSecondary)),
          TextButton(
            onPressed: controller.resetFilters,
            child: Text('reset_filters'.tr, style: const TextStyle(color: AppColors.gold)),
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
                   Text('advanced_filters'.tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 24),

              Text('practice_area'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              Text('location'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              Text('experience_years'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Slider(
                value: controller.minExperience.value.toDouble(),
                min: 0, max: 20, divisions: 4,
                activeColor: AppColors.gold,
                label: '${controller.minExperience.value}+ ${'years_plus'.tr}',
                onChanged: (val) => controller.minExperience.value = val.toInt(),
              )),

              const SizedBox(height: 24),
              Text('max_fee'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Slider(
                value: controller.maxFee.value,
                min: 500, max: 10000, divisions: 19,
                activeColor: AppColors.gold,
                label: '৳${controller.maxFee.value.toInt()}',
                onChanged: (val) => controller.maxFee.value = val,
              )),

              const SizedBox(height: 32),
              PrimaryButton(
                text: 'apply_filters'.tr,
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
                  child: Text('reset_all'.tr, style: const TextStyle(color: Colors.red)),
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
