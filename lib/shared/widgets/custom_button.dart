import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

// Custom Button Widget
// Reusable button component with consistent styling

enum ButtonType { primary, secondary, accent, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.icon,
    this.enabled = true,
  });

  Color get _backgroundColor {
    if (!enabled) return Colors.grey[300]!;
    
    switch (type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.secondary:
        return AppColors.secondary;
      case ButtonType.accent:
        return AppColors.accent;
      case ButtonType.outline:
        return Colors.transparent;
    }
  }

  Color get _textColor {
    if (!enabled) return Colors.grey[600]!;
    
    switch (type) {
      case ButtonType.primary:
        return AppColors.textLight;
      case ButtonType.secondary:
        return AppColors.textLight;
      case ButtonType.accent:
        return AppColors.primaryDark;
      case ButtonType.outline:
        return AppColors.primary;
    }
  }

  BorderSide? get _borderSide {
    if (type == ButtonType.outline) {
      return BorderSide(
        color: enabled ? AppColors.primary : Colors.grey[400]!,
        width: 1.5,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _textColor,
          elevation: type == ButtonType.outline ? 0 : 2,
          shadowColor: AppColors.shadow,
          side: _borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.button.copyWith(color: _textColor),
                  ),
                ],
              ),
      ),
    );
  }
}

// Specialized button for check-in flow
class CheckinButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  const CheckinButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.accent,
      enabled: enabled,
    );
  }
}
