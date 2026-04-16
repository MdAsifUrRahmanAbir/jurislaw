import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/lawyer_details_controller.dart';

class LawyerDetailsView extends GetView<LawyerDetailsController> {
  const LawyerDetailsView({super.key});

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
                  text: 'Book Consultation Now',
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
          _StepCircle(step: 1, current: controller.currentStep.value, label: 'Details'),
          _StepLine(step: 1, current: controller.currentStep.value),
          _StepCircle(step: 2, current: controller.currentStep.value, label: 'Preview'),
          _StepLine(step: 2, current: controller.currentStep.value),
          _StepCircle(step: 3, current: controller.currentStep.value, label: 'Payment'),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (controller.currentStep.value) {
      case 0: return 'Advocate Profile';
      case 1: return 'Book Appointment';
      case 2: return 'Booking Preview';
      case 3: return 'Choose Payment';
      default: return 'Advocate';
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
                          ' ${controller.lawyer.rating} (${controller.lawyer.reviewsCount} Reviews)',
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
              _QuickInfoItem(icon: Icons.location_on_outlined, label: 'Location', value: controller.lawyer.location.split(',').last.trim()),
              _QuickInfoItem(icon: Icons.history, label: 'Experience', value: '${controller.lawyer.experience}+ Yrs'),
              _QuickInfoItem(icon: Icons.payments_outlined, label: 'Fee', value: '৳${controller.lawyer.fee}'),
              _QuickInfoItem(icon: Icons.language, label: 'Language', value: controller.lawyer.languages.first),
              _QuickInfoItem(icon: Icons.check_circle_outline, label: 'Available', value: 'Today'),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader('Biography'),
              Text(controller.lawyer.bio, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
              
              const SizedBox(height: 24),
              _SectionHeader('Practice Areas'),
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
              _SectionHeader('Education & Qualification'),
              _ListInfoItem(Icons.school_outlined, controller.lawyer.education),

              const SizedBox(height: 24),
              _SectionHeader('Bar Council & Enrollment'),
              _ListInfoItem(Icons.assignment_ind_outlined, 'Enrollment No: ${controller.lawyer.barEnrollment}'),

              const SizedBox(height: 24),
              _SectionHeader('Languages'),
              Wrap(
                spacing: 8,
                children: controller.lawyer.languages.map((l) => Text('• $l', style: const TextStyle(color: AppColors.textSecondary))).toList(),
              ),

              const SizedBox(height: 24),
              _SectionHeader('Success Rate / Cases'),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text('Estimated Success Rate: ${controller.lawyer.successRate}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),

              const SizedBox(height: 24),
              _SectionHeader('Consultation Fee Details'),
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
                    _FeeRow('Virtual Consultation', '৳ ${controller.lawyer.fee}'),
                    const Divider(),
                    _FeeRow('Physical Meeting', '৳ ${controller.lawyer.fee + 1000}'),
                    const Divider(),
                    _FeeRow('Urgent Request', '৳ ${controller.lawyer.fee + 500}'),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _SectionHeader('Reviews & Feedback'),
              ...controller.lawyer.reviews.map((r) => _ReviewCard(review: r)),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _SectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }

  Widget _FeeRow(String label, String price) {
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
          const Text('Select Date', style: TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
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

          const Text('Available Slots', style: TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
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

          const Text('Consultation Type', style: TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Row(
            children: [
              _TypeIcon(
                icon: Icons.videocam_rounded, 
                label: 'Video', 
                isSelected: controller.consultationType.value == 'Video Call',
                onTap: () => controller.consultationType.value = 'Video Call',
              ),
              const SizedBox(width: 8),
              _TypeIcon(
                icon: Icons.phone_rounded, 
                label: 'Audio', 
                isSelected: controller.consultationType.value == 'Audio Call',
                onTap: () => controller.consultationType.value = 'Audio Call',
              ),
              const SizedBox(width: 8),
              _TypeIcon(
                icon: Icons.chat_bubble_rounded, 
                label: 'Chat', 
                isSelected: controller.consultationType.value == 'Chat',
                onTap: () => controller.consultationType.value = 'Chat',
              ),
            ],
          )),

          const SizedBox(height: AppSizes.gapLarge),

          const Text('Problem Description', style: TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
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

          const Text('Supporting Documents', style: TextStyle(fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold)),
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
                    ? 'Upload Case File (Optional)' 
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
                const Text('Total Consultation Fee', style: TextStyle(fontWeight: FontWeight.w500)),
                Text('৳ ${controller.lawyer.fee}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.gapXXLarge),

          PrimaryButton(
            text: 'Continue to Preview',
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
                    const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.gold, size: 20),
                      onPressed: () => controller.currentStep.value = 1,
                    ),
                  ],
                ),
                const Divider(height: 30),
                _PreviewItem(label: 'Advocate', value: controller.lawyer.name, icon: Icons.person_outline),
                _PreviewItem(label: 'Date & Time', value: '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year} at ${controller.selectedTime.value}', icon: Icons.calendar_today_outlined),
                _PreviewItem(label: 'Consultation Type', value: controller.consultationType.value, icon: Icons.videocam_outlined),
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payable Amount', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    Text('Incl. all taxes', style: TextStyle(color: AppColors.textHint, fontSize: 10)),
                  ],
                ),
                Text('৳ ${controller.lawyer.fee}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
          ),

          const SizedBox(height: 40),

          PrimaryButton(
            text: 'Confirm & Proceed to Pay',
            onPressed: controller.goToPayment,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => controller.currentStep.value = 1,
              child: const Text('Back to Edit', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
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
          const Text('Select your preferred payment method', style: TextStyle(color: AppColors.textSecondary)),
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
              'Secure Payment Gateway provided by Jurisheba',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
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

class _QuickInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _QuickInfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _ListInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ListInfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
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

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(review['date'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) => Icon(
              Icons.star, 
              size: 14, 
              color: index < review['rating'] ? Colors.orange : Colors.grey[300]
            )),
          ),
          const SizedBox(height: 8),
          Text(review['comment'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final int current;
  final String label;
  const _StepCircle({required this.step, required this.current, required this.label});

  @override
  Widget build(BuildContext context) {
    bool isCompleted = current > step;
    bool isActive = current == step;
    
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted || isActive ? AppColors.gold : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted 
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text('$step', style: TextStyle(color: isActive ? Colors.white : Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isActive ? AppColors.gold : Colors.grey[500], fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final int step;
  final int current;
  const _StepLine({required this.step, required this.current});

  @override
  Widget build(BuildContext context) {
    bool isCompleted = current > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14),
        color: isCompleted ? AppColors.gold : Colors.grey[200],
      ),
    );
  }
}
