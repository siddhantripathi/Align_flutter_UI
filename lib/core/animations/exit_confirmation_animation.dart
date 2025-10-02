import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Exit Confirmation Animation Widget
// Reusable exit confirmation with animation used in check-in flow

class ExitConfirmationWidget extends StatefulWidget {
  final VoidCallback onExit;
  final String confirmationText;
  
  const ExitConfirmationWidget({
    super.key,
    required this.onExit,
    this.confirmationText = "That's it for today?",
  });

  @override
  State<ExitConfirmationWidget> createState() => _ExitConfirmationWidgetState();
}

class _ExitConfirmationWidgetState extends State<ExitConfirmationWidget>
    with TickerProviderStateMixin {
  late AnimationController _exitAnimationController;
  late Animation<double> _exitAnimation;
  bool _showExitConfirmation = false;

  @override
  void initState() {
    super.initState();
    _exitAnimationController = AnimationController(
      duration: AppConstants.shortAnimationDuration,
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

  void _handleExitTap() {
    if (!_showExitConfirmation) {
      setState(() {
        _showExitConfirmation = true;
      });
      _exitAnimationController.forward();
      
      // Auto-hide after specified duration
      Future.delayed(
        const Duration(seconds: AppConstants.exitConfirmationDuration),
        () {
          if (mounted) {
            setState(() {
              _showExitConfirmation = false;
            });
            _exitAnimationController.reverse();
          }
        },
      );
    } else {
      // Second tap - actually exit
      widget.onExit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  color: _showExitConfirmation 
                      ? AppColors.textPrimary 
                      : AppColors.textLight,
                  size: 24,
                ),
                if (_showExitConfirmation) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.confirmationText,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
