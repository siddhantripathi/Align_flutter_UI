import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

// Earth Animation Widget
// Reusable animated earth icon used across multiple screens

class EarthAnimationWidget extends StatefulWidget {
  final double size;
  final Color color;
  
  const EarthAnimationWidget({
    super.key,
    this.size = 24,
    this.color = const Color(0xFF2196F3),
  });

  @override
  State<EarthAnimationWidget> createState() => _EarthAnimationWidgetState();
}

class _EarthAnimationWidgetState extends State<EarthAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _earthController;
  late Animation<double> _earthRotation;
  late Animation<double> _earthScale;

  @override
  void initState() {
    super.initState();
    _earthController = AnimationController(
      duration: AppConstants.earthAnimationDuration,
      vsync: this,
    );
    
    _earthRotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _earthController,
      curve: Curves.linear,
    ));
    
    _earthScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _earthController,
      curve: Curves.easeInOut,
    ));
    
    _earthController.repeat();
  }

  @override
  void dispose() {
    _earthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _earthController,
      builder: (context, child) {
        return Transform.scale(
          scale: _earthScale.value,
          child: Transform.rotate(
            angle: _earthRotation.value * 2 * 3.14159,
            child: Icon(
              Icons.public,
              color: widget.color,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}
