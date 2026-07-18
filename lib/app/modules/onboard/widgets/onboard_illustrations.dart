import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';

/// Renders a custom avatar face using basic Flutter shape widgets.
Widget buildPersonAvatar({
  required double size,
  required Color backgroundColor,
  bool hasGlasses = false,
  bool hasBeard = false,
  bool isWoman = false,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5),
    ),
    padding: const EdgeInsets.all(2),
    child: ClipOval(
      child: Container(
        color: backgroundColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Head/Face
            Positioned(
              top: size * 0.25,
              child: Container(
                width: size * 0.45,
                height: size * 0.45,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFDDB8), // Skin tone
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Hair
            Positioned(
              top: size * 0.15,
              child: isWoman
                  ? Container(
                      width: size * 0.55,
                      height: size * 0.4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E293B),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    )
                  : Container(
                      width: size * 0.48,
                      height: size * 0.2,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E293B),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ),
            ),
            // Women hair sides
            if (isWoman) ...[
              Positioned(
                top: size * 0.25,
                left: size * 0.15,
                child: Container(
                  width: size * 0.18,
                  height: size * 0.35,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size * 0.25,
                right: size * 0.15,
                child: Container(
                  width: size * 0.18,
                  height: size * 0.35,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
            // Glasses
            if (hasGlasses)
              Positioned(
                top: size * 0.38,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: size * 0.14,
                      height: size * 0.11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black87, width: 0.8),
                      ),
                    ),
                    Container(
                      width: size * 0.04,
                      height: 0.8,
                      color: Colors.black87,
                    ),
                    Container(
                      width: size * 0.14,
                      height: size * 0.11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black87, width: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            // Beard
            if (hasBeard)
              Positioned(
                top: size * 0.52,
                child: Container(
                  width: size * 0.32,
                  height: size * 0.18,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
              ),
            // Suit / Clothes
            Positioned(
              bottom: 0,
              child: Container(
                width: size * 0.75,
                height: size * 0.3,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shirt (white triangle)
                    Positioned(
                      top: 0,
                      child: ClipPath(
                        clipper: TriangleClipper(),
                        child: Container(
                          width: size * 0.22,
                          height: size * 0.16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Tie (red line)
                    if (!isWoman)
                      Positioned(
                        top: size * 0.05,
                        child: Container(
                          width: size * 0.04,
                          height: size * 0.16,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Custom painter to draw clean dotted circles.
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashCount = 50,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double sweepAngle = (2 * pi) / dashCount;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          i * sweepAngle,
          sweepAngle,
          false,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Draws connecting dotted lines between central circle and satellite elements.
class DottedConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final targets = [
      Offset(size.width * 0.8, size.height * 0.22),
      Offset(size.width * 0.82, size.height * 0.58),
      Offset(size.width * 0.18, size.height * 0.42),
    ];

    for (final target in targets) {
      _drawDashedLine(canvas, center, target, paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;
    final double distance = sqrt(dx * dx + dy * dy);

    // Start drawing after leaving the center circle radius (~90px)
    final double startRatio = 80 / distance;
    if (startRatio >= 1) return;

    final Offset start = Offset(p1.dx + dx * startRatio, p1.dy + dy * startRatio);
    // Stop drawing before entering target avatar radius (~23px)
    final double endRatio = (distance - 23) / distance;
    final Offset end = Offset(p1.dx + dx * endRatio, p1.dy + dy * endRatio);

    final double drawDx = end.dx - start.dx;
    final double drawDy = end.dy - start.dy;
    final double drawDistance = sqrt(drawDx * drawDx + drawDy * drawDy);

    const double dashLength = 4.0;
    const double spaceLength = 4.0;
    final int count = (drawDistance / (dashLength + spaceLength)).floor();

    for (int i = 0; i < count; i++) {
      final double ratio = i / count;
      final Offset from = Offset(start.dx + drawDx * ratio, start.dy + drawDy * ratio);

      final double toRatio = (i + 0.5) / count;
      final Offset to = Offset(start.dx + drawDx * toRatio, start.dy + drawDy * toRatio);

      canvas.drawLine(from, to, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// --- ONBOARD SCREEN 1 ILLUSTRATION ---
class OnboardIllustrationOne extends StatelessWidget {
  const OnboardIllustrationOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo "উকিল চাই" with a scale icon at top-left
          Positioned(
            top: 10,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.balance_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'উকিল চাই',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Connectors
          CustomPaint(
            size: const Size(double.infinity, 280),
            painter: DottedConnectorPainter(),
          ),

          // Central circle with dashed border
          CustomPaint(
            size: const Size(160, 160),
            painter: DashedCirclePainter(color: AppColors.gold.withOpacity(0.4), dashCount: 40),
          ),

          // Inside Center Circle (User sitting on sofa)
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFEFF6FF),
                  AppColors.greyLight.withOpacity(0.3),
                ],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sofa backrest
                Positioned(
                  bottom: -10,
                  child: Container(
                    width: 120,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                // Person shirt/head
                Positioned(
                  bottom: 12,
                  child: Column(
                    children: [
                      // Head
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFDDB8),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            // Hair
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1E293B),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Shirt (Mustard Yellow)
                      Container(
                        width: 54,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAB308),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Hands holding phone
                            Positioned(
                              bottom: 10,
                              child: Container(
                                width: 28,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFDDB8),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Container(
                                  width: 8,
                                  height: 12,
                                  color: Colors.black87, // Phone
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Satellites
          // 1. Top-Right Avatar (Male with glasses/tie)
          Positioned(
            top: 40,
            right: 50,
            child: buildPersonAvatar(
              size: 46,
              backgroundColor: const Color(0xFFEFF6FF),
              hasGlasses: true,
            ),
          ),
          // Location pin near Top-Right
          Positioned(
            top: 25,
            right: 105,
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.gold,
              size: 18,
            ),
          ),

          // 2. Middle-Right Avatar (Male with beard)
          Positioned(
            bottom: 60,
            right: 40,
            child: buildPersonAvatar(
              size: 46,
              backgroundColor: const Color(0xFFECFDF5),
              hasBeard: true,
            ),
          ),
          // Location pin near Middle-Right
          Positioned(
            bottom: 110,
            right: 70,
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.gold,
              size: 18,
            ),
          ),

          // 3. Middle-Left (Dark-blue circle with gold balance scale)
          Positioned(
            top: 100,
            left: 45,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.balance_rounded,
                color: AppColors.gold,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- ONBOARD SCREEN 2 ILLUSTRATION ---
class OnboardIllustrationTwo extends StatelessWidget {
  const OnboardIllustrationTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft leaves/foliage (drawn as gold icons/shapes)
          Positioned(
            left: 40,
            child: Opacity(
              opacity: 0.15,
              child: Transform.rotate(
                angle: -0.2,
                child: const Icon(Icons.eco_rounded, size: 72, color: AppColors.gold),
              ),
            ),
          ),
          Positioned(
            right: 40,
            child: Opacity(
              opacity: 0.15,
              child: Transform.rotate(
                angle: 0.2,
                child: const Icon(Icons.eco_rounded, size: 72, color: AppColors.gold),
              ),
            ),
          ),

          // Smartphone Mockup Frame
          Container(
            width: 170,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary, width: 5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Column(
                children: [
                  // Phone notch
                  Container(
                    width: 50,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Phone app header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'উকিল খুঁজুন',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Icon(Icons.tune_rounded, size: 10, color: AppColors.primary.withOpacity(0.7)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Search Field
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, size: 8, color: AppColors.primary.withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'উকিলের নাম বা বিষয় লিখুন',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 7,
                              color: AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Lawyer List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildPhoneLawyerCard(
                          name: 'মো: রাশেদুল ইসলাম',
                          specialty: 'ফৌজদারি আইন বিশেষজ্ঞ',
                          rating: '4.8 (120)',
                          avatarColor: const Color(0xFFEFF6FF),
                          hasGlasses: true,
                        ),
                        const SizedBox(height: 4),
                        _buildPhoneLawyerCard(
                          name: 'সায়মা রহমান',
                          specialty: 'সিভিল আইন বিশেষজ্ঞ',
                          rating: '4.7 (98)',
                          avatarColor: const Color(0xFFFDF2F8),
                          isWoman: true,
                        ),
                        const SizedBox(height: 4),
                        _buildPhoneLawyerCard(
                          name: 'তানভীর আহমেদ',
                          specialty: 'পারিবারিক আইন বিশেষজ্ঞ',
                          rating: '4.6 (76)',
                          avatarColor: const Color(0xFFECFDF5),
                          hasBeard: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Magnifying Glass overlay
          Positioned(
            bottom: 20,
            right: 60,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Transform.rotate(
                      angle: 0.78, // 45 degrees
                      child: Container(
                        width: 4,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLawyerCard({
    required String name,
    required String specialty,
    required String rating,
    required Color avatarColor,
    bool hasGlasses = false,
    bool hasBeard = false,
    bool isWoman = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.divider, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          buildPersonAvatar(
            size: 26,
            backgroundColor: avatarColor,
            hasGlasses: hasGlasses,
            hasBeard: hasBeard,
            isWoman: isWoman,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  specialty,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 6,
                    color: AppColors.primary.withOpacity(0.6),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 6, color: Colors.amber),
                    const SizedBox(width: 1),
                    Text(
                      rating,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 6,
                        color: AppColors.primary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.verified_user_rounded,
            color: AppColors.primary,
            size: 10,
          ),
        ],
      ),
    );
  }
}

/// --- ONBOARD SCREEN 3 ILLUSTRATION ---
class OnboardIllustrationThree extends StatelessWidget {
  const OnboardIllustrationThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Smartphone Mockup Frame
          Positioned(
            top: 10,
            child: Container(
              width: 170,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Column(
                  children: [
                    // Phone notch
                    Container(
                      width: 50,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                    // Chat Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      color: AppColors.primary,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios, size: 8, color: Colors.white.withOpacity(0.8)),
                          const SizedBox(width: 2),
                          buildPersonAvatar(
                            size: 18,
                            backgroundColor: Colors.blueAccent,
                          ),
                          const SizedBox(width: 4),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'অ্যাডভোকেট ফারহান হোসেন',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 6,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Online',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 5,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.phone, size: 8, color: Colors.white.withOpacity(0.8)),
                        ],
                      ),
                    ),

                    // Chat messages
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(4),
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildChatMessage(
                            text: 'আসসালামু আলাইকুম, কীভাবে সাহায্য করতে পারি?',
                            isMe: false,
                            time: '10:30 AM',
                          ),
                          _buildChatMessage(
                            text: 'আমার একটি জমি সংক্রান্ত সমস্যা আছে।',
                            isMe: true,
                            time: '10:31 AM',
                          ),
                          _buildChatMessage(
                            text: 'নিশ্চিত, আপনার কাগজপত্র পাঠান, আমি দেখে জানাচ্ছি।',
                            isMe: false,
                            time: '10:32 AM',
                          ),
                        ],
                      ),
                    ),

                    // Bottom message input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.greyLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Type a message...',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 6,
                                  color: AppColors.primary.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.send_rounded, size: 10, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Case progress card "আমার মামলা"
          Positioned(
            left: 20,
            bottom: 30,
            child: Container(
              width: 175,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'আমার মামলা',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'বিস্তারিত দেখুন >',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'জমি বিরোধ মামলা',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'চলমান',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Progress line steps: দাখিল -> শুনানি -> চলমান -> রায়
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTimelineDot(label: 'দাখিল', isActive: true),
                      _buildTimelineLine(isActive: true),
                      _buildTimelineDot(label: 'শুনানি', isActive: true),
                      _buildTimelineLine(isActive: true),
                      _buildTimelineDot(label: 'চলমান', isActive: true),
                      _buildTimelineLine(isActive: false),
                      _buildTimelineDot(label: 'রায়', isActive: false),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Calendar date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 8, color: AppColors.gold),
                      const SizedBox(width: 3),
                      Text(
                        '২০ মে ২০২৪',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 7,
                          color: AppColors.primary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating Security Shield next to the phone frame
          Positioned(
            right: 25,
            top: 70,
            child: Container(
              width: 38,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: AppColors.gold,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage({required String text, required bool isMe, required String time}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.greyLight,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(6),
            topRight: const Radius.circular(6),
            bottomLeft: isMe ? const Radius.circular(6) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 6.5,
                color: isMe ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              time,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 5,
                color: isMe ? Colors.white.withOpacity(0.6) : AppColors.primary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineDot({required String label, required bool isActive}) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 5.5,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 1.5,
        color: isActive ? Colors.green : Colors.grey[300],
        margin: const EdgeInsets.only(bottom: 8),
      ),
    );
  }
}
