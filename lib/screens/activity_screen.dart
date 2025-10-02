import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/animations/earth_animation.dart';
import '../data/models/wellness_module.dart';
import '../shared/widgets/custom_button.dart';

// Generic Activity Screen
// Dynamic template for starting any wellness module with content from Firebase

class ActivityScreen extends StatefulWidget {
  final WellnessModule module;

  const ActivityScreen({
    super.key,
    required this.module,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  WellnessActivity? _selectedActivity;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    // Select the first activity as default if available
    if (widget.module.activities.isNotEmpty) {
      _selectedActivity = widget.module.activities.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.module.title,
          style: AppTextStyles.headerTitleDark,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? Colors.red : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _isFavorited = !_isFavorited;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFavorited ? 'Added to favorites' : 'Removed from favorites'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Earth Animation - Dynamic content area
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const EarthAnimationWidget(
                size: 60,
                color: AppColors.accentBlue,
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Module content area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activity title - Dynamic from Firebase
                  Text(
                    _selectedActivity?.title ?? 'No Activity Available',
                    style: AppTextStyles.h2,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Favorite icon (top right of content area)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorited ? Colors.red : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Activity description - Dynamic from Firebase
                  Text(
                    _selectedActivity?.description ?? widget.module.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Duration indicator - Dynamic from Firebase
                  if (_selectedActivity != null && _selectedActivity!.durationMinutes > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Around ${_selectedActivity!.durationMinutes} min',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 40),
                  
                  // Start button
                  CustomButton(
                    text: "Let's begin",
                    type: ButtonType.accent,
                    onPressed: () => _startActivity(),
                    width: double.infinity,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Additional activities if available
                  if (widget.module.activities.length > 1) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Other Activities',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 16),
                    ...widget.module.activities
                        .where((activity) => activity != _selectedActivity)
                        .map((activity) => _buildActivityListItem(activity)),
                  ],
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityListItem(WellnessActivity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getActivityIcon(widget.module.contentType),
            color: AppColors.accentBlue,
            size: 20,
          ),
        ),
        title: Text(
          activity.title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: activity.durationMinutes > 0
            ? Text(
                '${activity.durationMinutes} min',
                style: AppTextStyles.bodySmall,
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: () {
          setState(() {
            _selectedActivity = activity;
          });
        },
      ),
    );
  }

  IconData _getActivityIcon(ContentType contentType) {
    switch (contentType) {
      case ContentType.guidedAudio:
        return Icons.headphones;
      case ContentType.article:
        return Icons.article;
      case ContentType.quiz:
        return Icons.quiz;
    }
  }

  void _startActivity() {
    if (_selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No activity selected')),
      );
      return;
    }

    // TODO: Implement activity start logic based on content type
    switch (widget.module.contentType) {
      case ContentType.guidedAudio:
        _startAudioActivity();
        break;
      case ContentType.article:
        _startArticleActivity();
        break;
      case ContentType.quiz:
        _startQuizActivity();
        break;
    }
  }

  void _startAudioActivity() {
    // TODO: Implement audio player
    // Navigate to audio player screen with _selectedActivity.audioUrl
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting audio: ${_selectedActivity!.title}'),
        action: SnackBarAction(
          label: 'TODO',
          onPressed: () {
            // TODO: Add audio player implementation
            // Example: AudioPlayerScreen.navigate(context, _selectedActivity!.audioUrl);
          },
        ),
      ),
    );
  }

  void _startArticleActivity() {
    // TODO: Implement article reader
    // Navigate to article reader screen with _selectedActivity.contentUrl
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening article: ${_selectedActivity!.title}'),
        action: SnackBarAction(
          label: 'TODO',
          onPressed: () {
            // TODO: Add article reader implementation
            // Example: ArticleReaderScreen.navigate(context, _selectedActivity!.contentUrl);
          },
        ),
      ),
    );
  }

  void _startQuizActivity() {
    // TODO: Implement quiz functionality
    // Navigate to quiz screen with _selectedActivity.contentUrl
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting quiz: ${_selectedActivity!.title}'),
        action: SnackBarAction(
          label: 'TODO',
          onPressed: () {
            // TODO: Add quiz implementation
            // Example: QuizScreen.navigate(context, _selectedActivity!.contentUrl);
          },
        ),
      ),
    );
  }
}
