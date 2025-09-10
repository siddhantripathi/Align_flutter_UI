import 'package:flutter/material.dart';
import 'checkin_screen.dart';
import 'checkin_final_screen.dart';

class MoodDepthScreen extends StatefulWidget {
  final MoodOption selectedMood;
  
  const MoodDepthScreen({
    super.key,
    required this.selectedMood,
  });

  @override
  State<MoodDepthScreen> createState() => _MoodDepthScreenState();
}

class _MoodDepthScreenState extends State<MoodDepthScreen> with TickerProviderStateMixin {
  late AnimationController _exitAnimationController;
  late Animation<double> _exitAnimation;
  bool _showExitConfirmation = false;
  
  final List<String> _selectedMoodTags = [];
  final List<String> _selectedWellness = [];
  final List<String> _selectedSocial = [];
  
  final List<String> _moodTags = [
    'Ecstatic', 'Optimistic', 'Confident', 'Joyful', 'Loving',
    'Strong', 'Playful', 'Generous', 'Inspired', 'Delighted',
    'Grateful', 'Peaceful', 'Energetic', 'Creative', 'Motivated',
    'Calm', 'Focused', 'Content', 'Excited', 'Proud'
  ];
  
  final List<WellnessActivity> _wellnessActivities = [
    WellnessActivity(name: 'Therapy', icon: Icons.psychology, color: Colors.purple),
    WellnessActivity(name: 'Exercise', icon: Icons.fitness_center, color: Colors.green),
    WellnessActivity(name: 'Meditation', icon: Icons.self_improvement, color: Colors.pink),
    WellnessActivity(name: 'Journaling', icon: Icons.edit_note, color: Colors.orange),
  ];
  
  final List<String> _socialActivities = [
    'Coffee with friends', 'Family dinner', 'Team meeting', 'Date night',
    'Book club', 'Gym buddy', 'Phone call', 'Video chat'
  ];

  @override
  void initState() {
    super.initState();
    _exitAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exitAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _exitAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _exitAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with animated exit button
            _buildHeader(),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Let's dive deeper section
                    _buildDiveDeeperSection(),
                    const SizedBox(height: 30),
                    
                    // What have you done today section
                    _buildTodaySection(),
                    const SizedBox(height: 30),
                    
                    // Continue button
                    _buildContinueButton(),
                    const SizedBox(height: 20),
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
            onTap: _handleExitTap,
            child: AnimatedBuilder(
              animation: _exitAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _showExitConfirmation 
                        ? Colors.grey[200]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close,
                        color: _showExitConfirmation ? Colors.black : Colors.black,
                        size: 24,
                      ),
                      if (_showExitConfirmation) ...[
                        const SizedBox(height: 4),
                        const Text(
                          "That's it for today?",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Check-in: depth',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _handleExitTap() {
    if (!_showExitConfirmation) {
      setState(() {
        _showExitConfirmation = true;
      });
      _exitAnimationController.forward();
      
      // Auto-hide after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showExitConfirmation = false;
          });
          _exitAnimationController.reverse();
        }
      });
    } else {
      // Second tap - actually exit to home
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    }
  }

  Widget _buildDiveDeeperSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Let's dive deeper",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        
        // Mood tags grid
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _moodTags.map((tag) => _buildMoodTag(tag)).toList(),
        ),
        const SizedBox(height: 16),
        
        // Give me more suggestions button
        GestureDetector(
          onTap: () {
            // Handle more suggestions
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('More suggestions coming soon!')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Give me more suggestions',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodTag(String tag) {
    final isSelected = _selectedMoodTags.contains(tag);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedMoodTags.remove(tag);
          } else {
            _selectedMoodTags.add(tag);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.orange, width: 1) : null,
        ),
        child: Text(
          tag,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What have you done today?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        
        // Wellness section
        _buildWellnessSection(),
        const SizedBox(height: 20),
        
        // Social section
        _buildSocialSection(),
      ],
    );
  }

  Widget _buildWellnessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Wellness',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Handle add wellness
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add wellness activity')),
                );
              },
              child: const Icon(Icons.add, color: Colors.grey, size: 20),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: 20),
          ],
        ),
        const SizedBox(height: 12),
        
        // Wellness activities grid
        Row(
          children: _wellnessActivities.map((activity) => 
            Expanded(
              child: _buildWellnessActivity(activity),
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildWellnessActivity(WellnessActivity activity) {
    final isSelected = _selectedWellness.contains(activity.name);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedWellness.remove(activity.name);
          } else {
            _selectedWellness.add(activity.name);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? activity.color.withOpacity(0.2) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: activity.color, width: 2) : null,
        ),
        child: Column(
          children: [
            Icon(
              activity.icon,
              color: isSelected ? activity.color : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              activity.name,
              style: TextStyle(
                color: isSelected ? activity.color : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Social',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Handle add social
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add social activity')),
                );
              },
              child: const Icon(Icons.add, color: Colors.grey, size: 20),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: 20),
          ],
        ),
        const SizedBox(height: 12),
        
        // Social activities horizontal scroll
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _socialActivities.length,
            itemBuilder: (context, index) {
              final activity = _socialActivities[index];
              final isSelected = _selectedSocial.contains(activity);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSocial.remove(activity);
                    } else {
                      _selectedSocial.add(activity);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? Border.all(color: Colors.blue, width: 1) : null,
                  ),
                  child: Text(
                    activity,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to final check-in screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckinFinalScreen(
                selectedMood: widget.selectedMood,
                selectedMoodTags: _selectedMoodTags,
                selectedWellness: _selectedWellness,
                selectedSocial: _selectedSocial,
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
          'Continue >',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class WellnessActivity {
  final String name;
  final IconData icon;
  final Color color;

  WellnessActivity({
    required this.name,
    required this.icon,
    required this.color,
  });
}
