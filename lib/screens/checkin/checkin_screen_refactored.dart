import 'package:flutter/material.dart';
import 'dart:math' as math;

// Core imports
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// Data imports
import '../../data/models/mood_option.dart';
import '../../data/repositories/checkin_repository.dart';

// Widget imports
import '../../shared/widgets/custom_button.dart';

// Screen imports
import 'mood_depth_screen_refactored.dart';

// Refactored Check-in Screen
// Uses new architecture with proper separation of concerns

class CheckInScreenRefactored extends StatefulWidget {
  const CheckInScreenRefactored({super.key});

  @override
  State<CheckInScreenRefactored> createState() => _CheckInScreenRefactoredState();
}

class _CheckInScreenRefactoredState extends State<CheckInScreenRefactored>
    with TickerProviderStateMixin {
  late final CheckinRepository _checkinRepository;
  late final List<MoodOption> _moods;
  
  int _selectedMoodIndex = 1; // Default to "Happy"
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  double _currentRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _checkinRepository = CheckinRepository();
    _moods = _checkinRepository.getMoodOptions();
    
    _rotationController = AnimationController(
      duration: AppConstants.shortAnimationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final center = Offset(
      MediaQuery.of(context).size.width / 2,
      100,
    );
    
    final delta = details.localPosition - center;
    final angle = math.atan2(delta.dy, delta.dx);
    
    double newRotation = (angle + math.pi / 2) % (2 * math.pi);
    if (newRotation < 0) newRotation += 2 * math.pi;
    
    setState(() {
      _currentRotation = newRotation;
      _updateSelectedMood();
    });
  }

  void _handlePanEnd() {
    _snapToNearestMood();
  }

  void _updateSelectedMood() {
    final anglePerMood = (2 * math.pi) / _moods.length;
    final normalizedRotation = (_currentRotation + anglePerMood / 2) % (2 * math.pi);
    final newIndex = (normalizedRotation / anglePerMood).floor() % _moods.length;
    
    if (newIndex != _selectedMoodIndex) {
      setState(() {
        _selectedMoodIndex = newIndex;
      });
    }
  }

  void _snapToNearestMood() {
    final anglePerMood = (2 * math.pi) / _moods.length;
    final targetRotation = _selectedMoodIndex * anglePerMood;
    
    _rotationController.reset();
    _rotationController.forward().then((_) {
      setState(() {
        _currentRotation = targetRotation;
      });
    });
  }

  void _navigateToDepthScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodDepthScreenRefactored(
          selectedMood: _moods[_selectedMoodIndex],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                ),
                child: Column(
                  children: [
                    _buildQuestion(),
                    _buildMoodDisplay(),
                    _buildSetMoodButton(),
                    _buildMoodSelector(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.textLight,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Check-in: Today, July 27',
            style: AppTextStyles.headerTitle,
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.calendar_today,
            color: AppColors.textLight,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
      child: Text(
        'How would you describe your mood?',
        style: AppTextStyles.h2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMoodDisplay() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
                SizedBox(height: 16),
                Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _moods[_selectedMoodIndex].emoji,
              style: AppTextStyles.emoji,
            ),
            const SizedBox(height: 8),
            Text(
              _moods[_selectedMoodIndex].name,
              style: AppTextStyles.moodName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetMoodButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
      child: CheckinButton(
        text: 'Set Mood >',
        onPressed: _navigateToDepthScreen,
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GestureDetector(
        onPanUpdate: _handlePanUpdate,
        onPanEnd: (details) => _handlePanEnd(),
        child: CustomPaint(
          size: const Size(double.infinity, 200),
          painter: CircularMoodSelectorPainter(
            selectedIndex: _selectedMoodIndex,
            moods: _moods,
            rotation: _currentRotation,
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Mood Selector
class CircularMoodSelectorPainter extends CustomPainter {
  final int selectedIndex;
  final List<MoodOption> moods;
  final double rotation;

  CircularMoodSelectorPainter({
    required this.selectedIndex,
    required this.moods,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width * 0.4;
    
    final paint = Paint()..style = PaintingStyle.fill;
    final anglePerMood = (2 * math.pi) / moods.length;
    
    // Draw mood segments
    for (int i = 0; i < moods.length; i++) {
      final startAngle = (i * anglePerMood) - math.pi / 2 + rotation;
      paint.color = moods[i].color.withOpacity(0.3);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        anglePerMood,
        true,
        paint,
      );
    }
    
    // Draw mood emojis
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < moods.length; i++) {
      final angle = (i * anglePerMood) - math.pi / 2 + rotation;
      final emojiX = center.dx + (radius * 0.7) * math.cos(angle);
      final emojiY = center.dy + (radius * 0.7) * math.sin(angle);
      
      if (angle >= -math.pi / 2 && angle <= math.pi / 2) {
        textPainter.text = TextSpan(
          text: moods[i].emoji,
          style: AppTextStyles.emojiSmall,
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(emojiX - textPainter.width / 2, emojiY - textPainter.height / 2),
        );
      }
    }
    
    // Draw pointer
    final pointerPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.fill;
    
    final pointerPath = Path();
    final pointerX = center.dx;
    final pointerY = center.dy - radius - 20;
    
    const pointerSize = 10.0;
    pointerPath.moveTo(pointerX, pointerY + pointerSize);
    pointerPath.lineTo(pointerX - pointerSize, pointerY - pointerSize);
    pointerPath.lineTo(pointerX + pointerSize, pointerY - pointerSize);
    pointerPath.close();
    
    canvas.drawPath(pointerPath, pointerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CircularMoodSelectorPainter && 
           (oldDelegate.selectedIndex != selectedIndex || 
            oldDelegate.rotation != rotation);
  }
}
