import 'package:flutter/material.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';

class QuickInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const QuickInfoItem({super.key, required this.icon, required this.label, required this.value});

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

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const ReviewCard({super.key, required this.review});

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

class StepCircle extends StatelessWidget {
  final int step;
  final int current;
  final String label;
  const StepCircle({super.key, required this.step, required this.current, required this.label});

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

class StepLine extends StatelessWidget {
  final int step;
  final int current;
  const StepLine({super.key, required this.step, required this.current});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: current > step ? AppColors.gold : Colors.grey[200],
      ),
    );
  }
}
