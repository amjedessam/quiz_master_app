import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_master_app/app/routes/app_routes.dart';

// ══════════════════════════════════════════════════════════════════
//  CONSTANTS
// ══════════════════════════════════════════════════════════════════

class _Constants {
  // Animation Durations
  static const transitionDuration = Duration(milliseconds: 600);
  static const pageChangeDuration = Duration(milliseconds: 400);
  static const floatDuration = Duration(seconds: 3);

  // Cloud
  static const double iconFloatRange = 10.0;

  // Button
  static const double buttonSize = 56.0;
  static const double buttonBorderRadius = 14.0;
  static const double chipBorderRadius = 24.0;

  // Dots
  static const double dotSize = 8.0;
  static const double activeDotWidth = 24.0;
}

// ══════════════════════════════════════════════════════════════════
//  THEME
// ══════════════════════════════════════════════════════════════════

class _Theme {
  // Primary Colors (Purple/Violet)
  static const primaryColor = Color(0xFF7C6AEF);
  static const primaryLight = Color(0xFFA599F7);
  static const primaryLighter = Color(0xFFBDB4FA);

  // Text Colors
  static const titleColor = Color(0xFF1A1A2E);
  static const descriptionColor = Color(0xFF6B7280);

  // Chip Colors
  static const chipBgColor = Color(0xFFEEEBFF);
  static const chipTextColor = Color(0xFF7C6AEF);

  // Text Styles
  static const titleStyle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: titleColor,
    height: 1.3,
  );

  static const descriptionStyle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    color: descriptionColor,
    height: 1.7,
    fontWeight: FontWeight.w400,
  );

  static const chipTextStyle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: chipTextColor,
  );

  static const skipButtonStyle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

// ══════════════════════════════════════════════════════════════════
//  PAGE MODEL
// ══════════════════════════════════════════════════════════════════

class _PageModel {
  final String imagePath; // مسار صورة PNG من assets
  final String chipText;
  final String title;
  final String subtitle;
  final String description;

  const _PageModel({
    required this.imagePath,
    required this.chipText,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

// ══════════════════════════════════════════════════════════════════
//  MAIN SCREEN
// ══════════════════════════════════════════════════════════════════

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  final _pageController = PageController();

  late AnimationController _floatController;
  late AnimationController _transitionController;

  late Animation<double> _cardSlide;
  late Animation<double> _cardFade;

  // ══════════════════════════════════════════════════════════════════
  //  بيانات الصفحات — غيّر مسارات الصور حسب ملفاتك
  // ══════════════════════════════════════════════════════════════════
  static const _pages = [
    _PageModel(
      imagePath: 'assets/images/onboarding_1.png',
      chipText: 'شرح ذكي',
      title: 'افهم دروسك',
      subtitle: 'بخطوات بسيطة',
      description:
          'اختر المادة والدرس، وسيقوم الذكاء الاصطناعي بشرحها لك بطريقة مبسطة وواضحة',
    ),
    _PageModel(
      imagePath: 'assets/images/onboarding_2.png',
      chipText: 'تدريب عملي',
      title: 'اختبر نفسك',
      subtitle: 'بشكل مستمر',
      description:
          'أنشئ اختباراتك بنفسك أو حل اختبارات المعلم وتدرّب على المنهج بشكل فعّال',
    ),
    _PageModel(
      imagePath: 'assets/images/onboarding_3.png',
      chipText: 'تحليل ذكي',
      title: 'حسّن مستواك',
      subtitle: 'خطوة بخطوة',
      description:
          'احصل على تحليل دقيق وشرح للأخطاء بعد كل اختبار لتتطور بشكل أسرع',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _initAnimations();
    _transitionController.forward();
  }

  void _setupSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _initAnimations() {
    _floatController = AnimationController(
      vsync: this,
      duration: _Constants.floatDuration,
    )..repeat(reverse: true);

    _transitionController = AnimationController(
      vsync: this,
      duration: _Constants.transitionDuration,
    );

    _cardSlide = Tween(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOutQuart,
      ),
    );

    _cardFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════
  //  التنقل للصفحة التالية
  // ══════════════════════════════════════════════════════════════════
  void _nextPage() {
    HapticFeedback.lightImpact();

    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: _Constants.pageChangeDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  // ══════════════════════════════════════════════════════════════════
  //  تخطي والذهاب لصفحة Login
  // ══════════════════════════════════════════════════════════════════
  void _skipToLogin() {
    HapticFeedback.mediumImpact();
    _navigateToLogin();
  }

  void _finishOnboarding() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _transitionController.forward(from: 0);
    HapticFeedback.selectionClick();
  }

  void _jumpToPage(int index) {
    if (index == _currentPage) return;
    HapticFeedback.lightImpact();

    _pageController.animateToPage(
      index,
      duration: _Constants.pageChangeDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLastPage = _currentPage == _pages.length - 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // ── الخلفية ─────────────────────────────────────────────
            _buildBackground(size),

            // ── محتوى الصفحات مع دعم السحب ──────────────────────────
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              physics: const BouncingScrollPhysics(),
              reverse: true, // عكس اتجاه السحب للعربية RTL
              itemBuilder: (_, index) => _buildPageContent(_pages[index], size),
            ),

            // ── زر التخطي (يظهر فقط في أول واجهتين) ─────────────────
            if (!isLastPage)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                child: _buildSkipButton(),
              ),

            // ── القسم الأبيض المنحني ─────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _transitionController,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, _cardSlide.value),
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: _buildWhiteSection(size),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  زر التخطي
  // ══════════════════════════════════════════════════════════════════
  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: _skipToLogin,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: const Text('تخطي', style: _Theme.skipButtonStyle),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  الخلفية البنفسجية مع الدوائر الزخرفية
  // ══════════════════════════════════════════════════════════════════
  Widget _buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFB5A8F8),
            Color(0xFF9B8CF5),
            Color(0xFF8579F2),
            Color(0xFF7C6AEF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // دائرة زخرفية كبيرة - أعلى اليمين
          Positioned(
            top: -size.width * 0.15,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 0.55,
              height: size.width * 0.55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          // دائرة زخرفية متوسطة - أعلى اليمين (داخلية)
          Positioned(
            top: size.height * 0.06,
            right: size.width * 0.12,
            child: Container(
              width: size.width * 0.38,
              height: size.width * 0.38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // دائرة زخرفية - يسار الوسط
          Positioned(
            top: size.height * 0.18,
            left: -size.width * 0.15,
            child: Container(
              width: size.width * 0.45,
              height: size.width * 0.45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  محتوى الصفحة — صورة مقصوصة بشكل السحابة
  // ══════════════════════════════════════════════════════════════════
  Widget _buildPageContent(_PageModel page, Size size) {
    // حجم السحابة: 82% من عرض الشاشة
    final cloudW = size.width * 0.82;
    final cloudH = cloudW * 0.75;

    return Column(
      children: [
        SizedBox(height: size.height * 0.10),

        // حاوية السحابة مع تأثير الطفو
        AnimatedBuilder(
          animation: _floatController,
          builder: (_, __) {
            final floatOffset =
                math.sin(_floatController.value * math.pi) *
                _Constants.iconFloatRange;

            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: SizedBox(
                width: cloudW,
                height: cloudH,
                child: Stack(
                  children: [
                    // ── 1) ظل السحابة ─────────────────────────────
                    CustomPaint(
                      size: Size(cloudW, cloudH),
                      painter: _CloudPainter(
                        cloudColor: Colors.transparent,
                        shadowColor: const Color(0x447C6AEF),
                      ),
                    ),

                    // ── 2) الصورة مقصوصة بشكل السحابة بالضبط ─────
                    ClipPath(
                      clipper: _CloudClipper(),
                      child: Image.asset(
                        page.imagePath,
                        width: cloudW,
                        height: cloudH,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: _Theme.primaryLighter.withOpacity(0.3),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 52,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // // ── 3) حدود السحابة البيضاء فوق الصورة ────────
                    // CustomPaint(
                    //   size: Size(cloudW, cloudH),
                    //   painter: _CloudBorderPainter(),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  القسم الأبيض المنحني
  // ══════════════════════════════════════════════════════════════════
  Widget _buildWhiteSection(Size size) {
    final page = _pages[_currentPage];
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        // الخلفية البيضاء مع المنحنى
        CustomPaint(
          size: Size(size.width, size.height * 0.52),
          painter: _SmoothCurvePainter(),
        ),
        // المحتوى
        Container(
          width: size.width,
          height: size.height * 0.52,
          padding: EdgeInsets.fromLTRB(28, 80, 28, bottomPadding + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── الشريحة (Chip) ──────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _Theme.chipBgColor,
                  borderRadius: BorderRadius.circular(
                    _Constants.chipBorderRadius,
                  ),
                ),
                child: Text(page.chipText, style: _Theme.chipTextStyle),
              ),
              const SizedBox(height: 20),

              // ── العنوان الرئيسي ─────────────────────────────────
              Text(
                page.title,
                textAlign: TextAlign.start,
                style: _Theme.titleStyle,
              ),
              Text(
                page.subtitle,
                textAlign: TextAlign.start,
                style: _Theme.titleStyle,
              ),
              const SizedBox(height: 14),

              // ── الوصف ───────────────────────────────────────────
              Text(
                page.description,
                textAlign: TextAlign.start,
                style: _Theme.descriptionStyle,
              ),

              const Spacer(),

              // ── الصف السفلي (النقاط + الزر) ─────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // نقاط التنقل
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return GestureDetector(
                        onTap: () => _jumpToPage(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(left: 8),
                          width: isActive
                              ? _Constants.activeDotWidth
                              : _Constants.dotSize,
                          height: _Constants.dotSize,
                          decoration: BoxDecoration(
                            color: isActive
                                ? _Theme.primaryColor
                                : _Theme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              _Constants.dotSize / 2,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  // زر التالي
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: _Constants.buttonSize,
                      height: _Constants.buttonSize,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_Theme.primaryLighter, _Theme.primaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          _Constants.buttonBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _Theme.primaryColor.withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  CLOUD PAINTER - رسم شكل السحابة مع الظل
// ══════════════════════════════════════════════════════════════════

class _CloudPainter extends CustomPainter {
  final Color shadowColor;
  final Color cloudColor;

  const _CloudPainter({
    this.shadowColor = const Color(0x337C6AEF),
    this.cloudColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── ظل السحابة ────────────────────────────────────────────────
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawPath(_buildCloudPath(w, h, offset: 10), shadowPaint);

    // ── جسم السحابة ───────────────────────────────────────────────
    if (cloudColor != Colors.transparent) {
      final cloudPaint = Paint()
        ..color = cloudColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawPath(_buildCloudPath(w, h), cloudPaint);
    }
  }

  Path _buildCloudPath(double w, double h, {double offset = 0}) {
    final path = Path();

    // قاعدة السحابة
    final baseRect = RRect.fromLTRBR(
      w * 0.05,
      h * 0.42 + offset,
      w * 0.95,
      h * 0.92 + offset,
      Radius.circular(h * 0.18),
    );
    path.addRRect(baseRect);

    // نتوء أيسر (صغير)
    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.28, h * 0.42 + offset),
        width: w * 0.34,
        height: h * 0.30,
      ),
    );

    // نتوء أوسط (أكبر - القمة)
    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.54, h * 0.30 + offset),
        width: w * 0.42,
        height: h * 0.38,
      ),
    );

    // نتوء أيمن (متوسط)
    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.76, h * 0.38 + offset),
        width: w * 0.32,
        height: h * 0.28,
      ),
    );

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════════════
//  CLOUD CLIPPER - قص الصورة بشكل السحابة بالضبط
// ══════════════════════════════════════════════════════════════════

class _CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    // نفس مسار _CloudPainter بالضبط (بدون offset)
    final baseRect = RRect.fromLTRBR(
      w * 0.05,
      h * 0.42,
      w * 0.95,
      h * 0.92,
      Radius.circular(h * 0.18),
    );
    path.addRRect(baseRect);

    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.28, h * 0.42),
        width: w * 0.34,
        height: h * 0.30,
      ),
    );

    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.54, h * 0.30),
        width: w * 0.42,
        height: h * 0.38,
      ),
    );

    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.76, h * 0.38),
        width: w * 0.32,
        height: h * 0.28,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ══════════════════════════════════════════════════════════════════
//  CLOUD BORDER PAINTER - حدود بيضاء شفافة فوق الصورة
// ══════════════════════════════════════════════════════════════════

class _CloudBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..isAntiAlias = true;

    final path = Path();

    final baseRect = RRect.fromLTRBR(
      w * 0.05,
      h * 0.42,
      w * 0.95,
      h * 0.92,
      Radius.circular(h * 0.18),
    );
    path.addRRect(baseRect);

    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.28, h * 0.42),
        width: w * 0.34,
        height: h * 0.30,
      ),
    );

    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.54, h * 0.30),
        width: w * 0.42,
        height: h * 0.38,
      ),
    );

    path.addOval(
      Rect.fromCenter(
        center: Offset(w * 0.76, h * 0.38),
        width: w * 0.32,
        height: h * 0.28,
      ),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════════════
//  SMOOTH CURVE PAINTER - رسم المنحنى الأبيض السفلي
// ══════════════════════════════════════════════════════════════════

class _SmoothCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 50);

    path.cubicTo(size.width * 0.75, 10, size.width * 0.25, 10, 0, 50);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
