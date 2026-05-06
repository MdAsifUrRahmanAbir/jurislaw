part of 'lawyer_details_view.dart';

class LawyerDetailsMobile extends GetView<LawyerDetailsController> {
  const LawyerDetailsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(_getTitle(), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gold),
          onPressed: controller.goBack,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (controller.currentStep.value > 0) _buildBookingStepper(),
                if (controller.currentStep.value == 0) _buildProfileView(),
                if (controller.currentStep.value == 1) _buildBookingForm(),
                if (controller.currentStep.value == 2) _buildPreview(),
                if (controller.currentStep.value == 3) _buildPaymentOptions(),
                const SizedBox(height: 100), // Space for sticky button
              ],
            ),
          ),
          if (controller.currentStep.value == 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSizes.paddingMid),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5)),
                  ],
                ),
                child: PrimaryButton(
                  text: 'book_consultation_now'.tr,
                  onPressed: controller.goToBooking,
                ),
              ),
            ),
        ],
      ),
    ));
  }

  Widget _buildBookingStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: AppSizes.paddingMid),
      color: Colors.white,
      child: Row(
        children: [
          StepCircle(step: 1, current: controller.currentStep.value, label: 'details'.tr),
          StepLine(step: 1, current: controller.currentStep.value),
          StepCircle(step: 2, current: controller.currentStep.value, label: 'preview'.tr),
          StepLine(step: 2, current: controller.currentStep.value),
          StepCircle(step: 3, current: controller.currentStep.value, label: 'payment'.tr),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (controller.currentStep.value) {
      case 0: return 'advocate_profile'.tr;
      case 1: return 'book_appointment'.tr;
      case 2: return 'booking_preview'.tr;
      case 3: return 'choose_payment'.tr;
      default: return 'lawyer'.tr;
    }
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSizes.radiusXLarge),
              bottomRight: Radius.circular(AppSizes.radiusXLarge),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                child: Image.network(
                  controller.lawyer.photo,
                  width: 90, height: 90, fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AppSizes.gapMid),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.lawyer.name,
                      style: const TextStyle(color: Colors.white, fontSize: AppSizes.fontXLarge, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      controller.lawyer.specialty,
                      style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.gold, size: 16),
                        Text(
                          ' ${controller.lawyer.rating} (${controller.lawyer.reviewsCount} ${'More'})',
                          style: const TextStyle(color: Colors.white70, fontSize: AppSizes.fontXS),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Quick Info Row
        Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
            children: [
              QuickInfoItem(icon: Icons.location_on_outlined, label: 'location'.tr, value: controller.lawyer.location.split(',').last.trim()),
              QuickInfoItem(icon: Icons.history, label: 'experience_years'.tr, value: '${controller.lawyer.experience}+ ${'years_plus'.tr}'),
              QuickInfoItem(icon: Icons.payments_outlined, label: 'Fee', value: '৳${controller.lawyer.fee}'),
              QuickInfoItem(icon: Icons.language, label: 'language'.tr, value: controller.lawyer.languages.first),
              QuickInfoItem(icon: Icons.check_circle_outline, label: 'Available', value: 'Today'),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('biography'.tr),
              Text(controller.lawyer.bio, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
              
              const SizedBox(height: 24),
              _sectionHeader('practice_area'.tr),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: controller.lawyer.practiceAreas.map((area) => Chip(
                  label: Text(area),
                  backgroundColor: AppColors.gold.withOpacity(0.1),
                  labelStyle: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                )).toList(),
              ),

              const SizedBox(height: 24),
              _sectionHeader('education_qualification'.tr),
              _listInfoItem(Icons.school_outlined, controller.lawyer.education),

              const SizedBox(height: 24),
              _sectionHeader('bar_council_enrollment'.tr),
              _listInfoItem(Icons.assignment_ind_outlined, 'Enrollment No: ${controller.lawyer.barEnrollment}'),

              const SizedBox(height: 24),
              _sectionHeader('language'.tr),
              Wrap(
                spacing: 8,
                children: controller.lawyer.languages.map((l) => Text('• $l', style: const TextStyle(color: AppColors.textSecondary))).toList(),
              ),

              const SizedBox(height: 24),
              _sectionHeader('success_rate_cases'.tr),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text('Estimated Success Rate: ${controller.lawyer.successRate}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),

              const SizedBox(height: 24),
              _sectionHeader('consultation_fee_details'.tr),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _feeRow('virtual_consultation'.tr, '৳ ${controller.lawyer.fee}'),
                    const Divider(),
                    _feeRow('physical_meeting'.tr, '৳ ${controller.lawyer.fee + 1000}'),
                    const Divider(),
                    _feeRow('urgent_request'.tr, '৳ ${controller.lawyer.fee + 500}'),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _sectionHeader('reviews_feedback'.tr),
              ...controller.lawyer.reviews.map((r) => ReviewCard(review: r)),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }

  Widget _feeRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('select_date'.tr, style: const TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                return Obx(() {
                  final isSelected = controller.selectedDate.value.day == date.day;
                  return GestureDetector(
                    onTap: () => controller.selectDate(date),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.gold : Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
                            style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 12),
                          ),
                          Text(
                            '${date.day}',
                            style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          const SizedBox(height: AppSizes.gapLarge),

          Text('available_slots'.tr, style: const TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
            spacing: 8,
            children: controller.availableTimes.map((time) {
              final isSelected = controller.selectedTime.value == time;
              return ChoiceChip(
                label: Text(time),
                selected: isSelected,
                onSelected: (val) => controller.selectedTime.value = time,
                selectedColor: AppColors.gold,
                labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              );
            }).toList(),
          )),

          const SizedBox(height: AppSizes.gapLarge),

          Text('consultation_type'.tr, style: const TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Row(
            children: [
              _TypeIcon(
                icon: Icons.videocam_rounded, 
                label: 'video_call'.tr, 
                isSelected: controller.consultationType.value == 'Video Call',
                onTap: () => controller.consultationType.value = 'Video Call',
              ),
              const SizedBox(width: 8),
              _TypeIcon(
                icon: Icons.phone_rounded, 
                label: 'audio_call'.tr, 
                isSelected: controller.consultationType.value == 'Audio Call',
                onTap: () => controller.consultationType.value = 'Audio Call',
              ),
              const SizedBox(width: 8),
              _TypeIcon(
                icon: Icons.chat_bubble_rounded, 
                label: 'chat_only'.tr, 
                isSelected: controller.consultationType.value == 'Chat',
                onTap: () => controller.consultationType.value = 'Chat',
              ),
            ],
          )),

          const SizedBox(height: AppSizes.gapLarge),

          Text('problem_description'.tr, style: const TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.problemDescription,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Briefly describe your legal concern...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),

          const SizedBox(height: AppSizes.gapLarge),

          Text('supporting_documents'.tr, style: const TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: controller.uploadDocument,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Obx(() => Text(
                    controller.uploadedFileName.value.isEmpty 
                    ? 'upload_case_file'.tr 
                    : controller.uploadedFileName.value,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  )),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.gapXLarge),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('total_consultation_fee'.tr, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text('৳ ${controller.lawyer.fee}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.gapXXLarge),

          PrimaryButton(
            text: 'continue_to_preview'.tr,
            onPressed: controller.goToPreview,
          ),
          const SizedBox(height: AppSizes.gapXXLarge),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description_outlined, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Text('order_summary'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.gold, size: 20),
                      onPressed: () => controller.currentStep.value = 1,
                    ),
                  ],
                ),
                const Divider(height: 30),
                _PreviewItem(label: 'lawyer'.tr, value: controller.lawyer.name, icon: Icons.person_outline),
                _PreviewItem(label: 'Date & Time', value: '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year} at ${controller.selectedTime.value}', icon: Icons.calendar_today_outlined),
                _PreviewItem(label: 'consultation_type'.tr, value: controller.consultationType.value, icon: Icons.videocam_outlined),
                _PreviewItem(label: 'Subject', value: controller.problemDescription.text.isEmpty ? 'Not specified' : controller.problemDescription.text, icon: Icons.info_outline),
                _PreviewItem(label: 'Attached File', value: controller.uploadedFileName.value.isEmpty ? 'No file' : controller.uploadedFileName.value, icon: Icons.attach_file),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('payable_amount'.tr, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    Text('incl_all_taxes'.tr, style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
                  ],
                ),
                Text('৳ ${controller.lawyer.fee}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
          ),

          const SizedBox(height: 40),

          PrimaryButton(
            text: 'confirm_proceed_to_pay'.tr,
            onPressed: controller.goToPayment,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => controller.currentStep.value = 1,
              child: Text('back_to_edit'.tr, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('payment_method_select_hint'.tr, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          
          Obx(() => Column(
            children: [
              _PaymentTile(
                logo: 'https://seeklogo.com/images/B/bkash-logo-01F0959E6D-seeklogo.com.png', 
                label: 'bKash', 
                isSelected: controller.selectedPaymentMethod.value == 'bKash',
                onTap: () => controller.selectPaymentMethod('bKash'),
              ),
              _PaymentTile(
                logo: 'https://seeklogo.com/images/N/nagad-logo-7A70BBDA00-seeklogo.com.png', 
                label: 'Nagad', 
                isSelected: controller.selectedPaymentMethod.value == 'Nagad',
                onTap: () => controller.selectPaymentMethod('Nagad'),
              ),
              _PaymentTile(
                logo: 'https://seeklogo.com/images/R/rocket-logo-8A3B2943A6-seeklogo.com.png', 
                label: 'Rocket', 
                isSelected: controller.selectedPaymentMethod.value == 'Rocket',
                onTap: () => controller.selectPaymentMethod('Rocket'),
              ),
              _PaymentTile(
                icon: Icons.credit_card, 
                label: 'Debit / Credit Card', 
                isSelected: controller.selectedPaymentMethod.value == 'Card',
                onTap: () => controller.selectPaymentMethod('Card'),
              ),
            ],
          )),

          const SizedBox(height: 40),
          
          Obx(() => PrimaryButton(
            text: controller.selectedPaymentMethod.isEmpty 
              ? 'Select a method' 
              : 'Pay ৳ ${controller.lawyer.fee} with ${controller.selectedPaymentMethod.value}',
            onPressed: controller.selectedPaymentMethod.isEmpty ? null : controller.finalizePayment,
            isLoading: controller.isProcessingPayment.value,
          )),

          const SizedBox(height: 20),
          Center(
            child: Text(
              'secure_gateway_msg'.tr,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listInfoItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary))),
      ],
    );
  }
}

class _PreviewItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  const _PreviewItem({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.textHint),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String? logo;
  final IconData? icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({this.logo, this.icon, required this.label, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        selected: isSelected,
        tileColor: isSelected ? AppColors.gold.withOpacity(0.05) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: isSelected ? AppColors.gold : AppColors.divider, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        leading: logo != null 
          ? Image.network(logo!, width: 40) 
          : Icon(icon, color: isSelected ? AppColors.gold : AppColors.primary, size: 30),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.gold : AppColors.textPrimary)),
        trailing: isSelected 
          ? const Icon(Icons.check_circle, color: AppColors.gold)
          : const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeIcon({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            border: Border.all(color: isSelected ? AppColors.gold : AppColors.divider),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.gold : AppColors.textSecondary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
