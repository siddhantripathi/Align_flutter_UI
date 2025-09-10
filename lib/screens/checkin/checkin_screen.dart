import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'mood_depth_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> with TickerProviderStateMixin {
  int _selectedMoodIndex = 1; // Default to "Happy" (middle option)
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  double _currentRotation = 0.0;
  
  final List<MoodOption> _moods = [
    MoodOption(
      emoji: '😐',
      name: 'Neutral',
      color: Colors.grey,
    ),
    MoodOption(
      emoji: '😊',
      name: 'Happy',
      color: Colors.yellow,
    ),
    MoodOption(
      emoji: '😠',
      name: 'Angry',
      color: Colors.red,
    ),
    MoodOption(
      emoji: '😢',
      name: 'Sad',
      color: Colors.blue,
    ),
    MoodOption(
      emoji: '😴',
      name: 'Tired',
      color: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // Dark grey background
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button and date
            _buildHeader(),
            
            // Main content area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Question
                    _buildQuestion(),
                    
                    // Mood display area
                    _buildMoodDisplay(),
                    
                    // Set Mood button
                    _buildSetMoodButton(),
                    
                    // Mood selector at bottom
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
      padding: const EdgeInsets.all(20),
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
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Check-in: Today, July 27',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
      child: Text(
        'How would you describe your mood?',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
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
            // Scroll indicators
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
                SizedBox(height: 16),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            
            // Large emoji
            Text(
              _moods[_selectedMoodIndex].emoji,
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 8),
            
            // Mood name
            Text(
              _moods[_selectedMoodIndex].name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetMoodButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to mood depth page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoodDepthScreen(
                  selectedMood: _moods[_selectedMoodIndex],
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB6C1), // Light pink
            foregroundColor: const Color(0xFF4A4A4A), // Dark grey text
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Set Mood >',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GestureDetector(
        onPanUpdate: (details) {
          _handlePanUpdate(details);
        },
        onPanEnd: (details) {
          _handlePanEnd();
        },
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

  void _handlePanUpdate(DragUpdateDetails details) {
    final center = Offset(
      MediaQuery.of(context).size.width / 2,
      100, // Half of the new container height (200)
    );
    
    final delta = details.localPosition - center;
    final angle = math.atan2(delta.dy, delta.dx);
    
    // Convert angle to rotation (0 to 2π)
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
}

class MoodOption {
  final String emoji;
  final String name;
  final Color color;

  MoodOption({
    required this.emoji,
    required this.name,
    required this.color,
  });
}

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
    final center = Offset(size.width / 2, size.height - 20); // Position at bottom
    final radius = size.width * 0.4; // Make it larger to show only current + partial adjacent
    
    // Draw semi-circular segments (only bottom half visible)
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final anglePerMood = (2 * math.pi) / moods.length;
    
    for (int i = 0; i < moods.length; i++) {
      final startAngle = (i * anglePerMood) - math.pi / 2 + rotation;
      final sweepAngle = anglePerMood;
      
      paint.color = moods[i].color.withOpacity(0.3);
      
      // Only draw the bottom half of the circle
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }
    
    // Draw mood emojis positioned around the circle
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < moods.length; i++) {
      final angle = (i * anglePerMood) - math.pi / 2 + rotation;
      final emojiX = center.dx + (radius * 0.7) * math.cos(angle);
      final emojiY = center.dy + (radius * 0.7) * math.sin(angle);
      
      // Only draw emojis that are in the visible bottom half
      if (angle >= -math.pi / 2 && angle <= math.pi / 2) {
        textPainter.text = TextSpan(
          text: moods[i].emoji,
          style: const TextStyle(
            fontSize: 35,
            color: Colors.black,
          ),
        );
        
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(emojiX - textPainter.width / 2, emojiY - textPainter.height / 2),
        );
      }
    }
    
    // Draw fixed pointer at the top center
    final pointerPaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..style = PaintingStyle.fill;
    
    final pointerPath = Path();
    final pointerX = center.dx;
    final pointerY = center.dy - radius - 20; // Position above the circle
    
    // Draw triangular pointer pointing down
    final pointerSize = 10.0;
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
