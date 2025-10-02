import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/animations/earth_animation.dart';
import '../../data/providers/auth_provider.dart';
import 'custom_button.dart';

// Check-in Completion Overlay
// Modal overlay that appears after successful check-in completion

class CheckinCompletionOverlay extends StatelessWidget {
  final VoidCallback onClose;
  final String? userName;

  const CheckinCompletionOverlay({
    super.key,
    required this.onClose,
    this.userName,
  });

  static Future<void> show(BuildContext context, {String? userName}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CheckinCompletionOverlay(
        userName: userName,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Earth animation with happy face
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const EarthAnimationWidget(
                    size: 60,
                    color: AppColors.accentBlue,
                  ),
                  // Happy face overlay
                  Positioned(
                    bottom: 25,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '😊',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Success message
            Text(
              'Thanks for checking in today!',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Personalized message
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final displayName = userName ?? authProvider.user?.firstName ?? 'User';
                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: "You're doing "),
                      TextSpan(
                        text: "amazing",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "!\nSee you tomorrow, $displayName"),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Motivational text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Keep tracking your mood daily so we\ncan help you improve your wellness.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Close button
            CustomButton(
              text: 'Close',
              type: ButtonType.accent,
              onPressed: onClose,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
