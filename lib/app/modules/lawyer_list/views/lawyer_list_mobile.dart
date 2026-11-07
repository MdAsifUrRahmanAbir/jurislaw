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
              controller: controller.searchCtrl,
              textInputAction: TextInputAction.search,
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
              onChanged: controller.onSearchChanged,
            ),
          ),

          // Filter Chips Row
          _buildActiveFilters(),

          // Result List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.filteredLawyers.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.gold));
              }
              return RefreshIndicator(
                color: AppColors.gold,
                onRefresh: controller.refreshList,
                child: controller.filteredLawyers.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: controller.scrollCtrl,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(AppSizes.paddingMid),
                        itemCount: controller.filteredLawyers.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.filteredLawyers.length) {
                            return Obx(() => controller.isLoadingMore.value
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
                                  )
                                : const SizedBox(height: 16));
                          }
                          return LawyerCard(lawyer: controller.filteredLawyers[index]);
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Obx(() {
      if (!controller.hasActiveFilters) return const SizedBox.shrink();

      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (controller.selectedSort.value != 'recommended')
              FilterChipWidget(label: 'sort_${controller.selectedSort.value}'.tr, onClear: controller.clearSort),
            if (controller.selectedArea.value.isNotEmpty)
              FilterChipWidget(label: controller.selectedArea.value, onClear: controller.clearArea),
            if (controller.selectedDivision.value.isNotEmpty)
              FilterChipWidget(label: controller.selectedDivision.value, onClear: controller.clearDivision),
            if (controller.selectedDistrict.value.isNotEmpty)
              FilterChipWidget(label: controller.selectedDistrict.value, onClear: controller.clearDistrict),
            if (controller.availableOnly.value)
              FilterChipWidget(label: 'available_only'.tr, onClear: controller.clearAvailableOnly),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    // ListView so pull-to-refresh still works on an empty result.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('no_advocates_found'.tr, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
        Center(
          child: TextButton(
            onPressed: controller.resetFilters,
            child: Text('reset_filters'.tr, style: const TextStyle(color: AppColors.gold)),
          ),
        ),
      ],
    );
  }

  Widget _choiceWrap({
    required RxList<String> options,
    required RxString selected,
    String Function(String)? labelOf,
  }) {
    return Obx(() => Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ChoiceChip(
              label: Text('all'.tr),
              selected: selected.value.isEmpty,
              onSelected: (_) => selected.value = '',
              selectedColor: AppColors.gold.withValues(alpha: 0.2),
            ),
            ...options.map((opt) => ChoiceChip(
                  label: Text(labelOf?.call(opt) ?? opt),
                  selected: selected.value == opt,
                  onSelected: (_) => selected.value = opt,
                  selectedColor: AppColors.gold.withValues(alpha: 0.2),
                  labelStyle: TextStyle(color: selected.value == opt ? AppColors.gold : Colors.black),
                )),
          ],
        ));
  }

  void _showFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
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
              const SizedBox(height: 16),

              Text('sort_by'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: controller.sorts
                        .map((s) => ChoiceChip(
                              label: Text('sort_$s'.tr),
                              selected: controller.selectedSort.value == s,
                              onSelected: (_) => controller.selectedSort.value = s,
                              selectedColor: AppColors.gold.withValues(alpha: 0.2),
                              labelStyle: TextStyle(
                                  color: controller.selectedSort.value == s ? AppColors.gold : Colors.black),
                            ))
                        .toList(),
                  )),

              if (controller.areas.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('practice_area'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _choiceWrap(options: controller.areas, selected: controller.selectedArea),
              ],

              if (controller.divisions.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('division'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _choiceWrap(options: controller.divisions, selected: controller.selectedDivision),
              ],

              if (controller.districts.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('district'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _choiceWrap(options: controller.districts, selected: controller.selectedDistrict),
              ],

              const SizedBox(height: 16),
              Obx(() => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.gold,
                    title: Text('available_only'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    value: controller.availableOnly.value,
                    onChanged: (v) => controller.availableOnly.value = v,
                  )),

              const SizedBox(height: 24),
              PrimaryButton(
                text: 'apply_filters'.tr,
                onPressed: () {
                  Get.back();
                  controller.applyFilters();
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    controller.resetFilters();
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
