import 'package:flutter/material.dart';
import 'checkin_screen.dart';
import '../../shared/widgets/checkin_completion_overlay.dart';

class CheckinFinalScreen extends StatefulWidget {
  final MoodOption selectedMood;
  final List<String> selectedMoodTags;
  final List<String> selectedWellness;
  final List<String> selectedSocial;
  
  const CheckinFinalScreen({
    super.key,
    required this.selectedMood,
    required this.selectedMoodTags,
    required this.selectedWellness,
    required this.selectedSocial,
  });

  @override
  State<CheckinFinalScreen> createState() => _CheckinFinalScreenState();
}

class _CheckinFinalScreenState extends State<CheckinFinalScreen> with TickerProviderStateMixin {
  late AnimationController _exitAnimationController;
  late Animation<double> _exitAnimation;
  bool _showExitConfirmation = false;
  
  final TextEditingController _textController = TextEditingController();
  final List<String> _selectedPhotos = [];
  bool _isRecording = false;

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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // Dark grey background
      body: SafeArea(
        child: Column(
          children: [
            // Header with animated exit button
            _buildHeader(),
            
            // Main content area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add more details section
                      _buildAddMoreDetailsSection(),
                      const SizedBox(height: 30),
                      
                      // Photos section
                      _buildPhotosSection(),
                      const SizedBox(height: 30),
                      
                      // Voice Memo section
                      _buildVoiceMemoSection(),
                      const SizedBox(height: 30),
                      
                      // Save button
                      _buildSaveButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
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
                        color: _showExitConfirmation ? Colors.black : Colors.white,
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

  Widget _buildAddMoreDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add more details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: _textController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'More about today...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildPhotoButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera feature coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPhotoButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery feature coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4DB6AC), width: 1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4DB6AC),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF4DB6AC),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceMemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Memo',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        
        GestureDetector(
          onTap: () {
            setState(() {
              _isRecording = !_isRecording;
            });
            
            if (_isRecording) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recording started...')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recording stopped!')),
              );
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: _isRecording ? Colors.red[50] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isRecording ? Colors.red : const Color(0xFF4DB6AC),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: _isRecording ? Colors.red : const Color(0xFF4DB6AC),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _isRecording ? 'Stop Recording' : 'Tap to Record',
                  style: TextStyle(
                    color: _isRecording ? Colors.red : const Color(0xFF4DB6AC),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Handle save
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check-in saved successfully!')),
          );
          
          // Show completion overlay first
          await CheckinCompletionOverlay.show(context);
          
          // Then navigate back to home
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB6C1), // Light pink
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
