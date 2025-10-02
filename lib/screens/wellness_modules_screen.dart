import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/wellness_module.dart';
import '../data/services/firebase_service.dart';
import 'activity_screen.dart';

// Wellness Modules Screen
// Displays categorized wellness modules (Practice Wellness / Learn Wellness)

class WellnessModulesScreen extends StatefulWidget {
  final String type; // 'practice' or 'learn'
  final String title; // 'Practice Wellness' or 'Learn Wellness'

  const WellnessModulesScreen({
    super.key,
    required this.type,
    required this.title,
  });

  @override
  State<WellnessModulesScreen> createState() => _WellnessModulesScreenState();
}

class _WellnessModulesScreenState extends State<WellnessModulesScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<WellnessModule> _modules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    try {
      final modules = await _firebaseService.getWellnessModules(widget.type);
      setState(() {
        _modules = modules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading modules: $e')),
        );
      }
    }
  }

  List<WellnessModule> _getModulesByCategory(WellnessCategory category) {
    return _modules.where((module) => module.category == category).toList();
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
          widget.title,
          style: AppTextStyles.headerTitleDark,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommended for you section
                  _buildSection(
                    'Recommended for you',
                    _getModulesByCategory(WellnessCategory.recommended),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Mindfulness section
                  _buildSection(
                    'Mindfulness',
                    _getModulesByCategory(WellnessCategory.mindfulness),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Self-Alignment section
                  _buildSection(
                    'Self-Alignment',
                    _getModulesByCategory(WellnessCategory.selfAlignment),
                  ),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSection(String title, List<WellnessModule> modules) {
    if (modules.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            return _buildModuleCard(modules[index]);
          },
        ),
      ],
    );
  }

  Widget _buildModuleCard(WellnessModule module) {
    return GestureDetector(
      onTap: () {
        if (!module.isLocked && !module.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityScreen(module: module),
            ),
          );
        } else if (module.isLocked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This module is locked. Complete previous modules to unlock.')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: module.isEmpty ? Colors.grey[100] : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: module.isEmpty ? Colors.grey[300]! : Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: module.isEmpty ? null : [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay icons
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      width: double.infinity,
                      color: module.isEmpty 
                          ? Colors.grey[200] 
                          : _getModuleColor(module.contentType).withOpacity(0.3),
                      child: module.imageUrl != null && !module.isEmpty
                          ? Image.network(
                              module.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(module),
                            )
                          : _buildPlaceholderImage(module),
                    ),
                  ),
                  
                  // Content type icon
                  if (!module.isEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildContentTypeIcon(module.contentType),
                    ),
                  
                  // Lock icon
                  if (module.isLocked)
                    const Positioned(
                      bottom: 8,
                      left: 8,
                      child: Icon(
                        Icons.lock,
                        color: AppColors.textLight,
                        size: 16,
                      ),
                    ),
                  
                  // Star icon
                  if (module.isStarred)
                    const Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
                        color: AppColors.accentDark,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
            
            // Title and arrow
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        module.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: module.isEmpty ? AppColors.textSecondary : AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!module.isEmpty && !module.isLocked)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTypeIcon(ContentType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case ContentType.guidedAudio:
        icon = Icons.headphones;
        color = AppColors.accentBlue;
        break;
      case ContentType.article:
        icon = Icons.article;
        color = AppColors.secondary;
        break;
      case ContentType.quiz:
        icon = Icons.quiz;
        color = Colors.purple;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildPlaceholderImage(WellnessModule module) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 32,
              color: module.isEmpty ? Colors.grey[400] : _getModuleColor(module.contentType),
            ),
            if (module.isEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Coming Soon',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getModuleColor(ContentType contentType) {
    switch (contentType) {
      case ContentType.guidedAudio:
        return AppColors.accentBlue;
      case ContentType.article:
        return AppColors.secondary;
      case ContentType.quiz:
        return Colors.purple;
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0, false),
          _buildNavItem(Icons.search, 'Search', 1, false),
          _buildNavItem(Icons.favorite, 'Wellness', 2, true),
          _buildNavItem(Icons.military_tech, 'Badges', 3, false),
          _buildNavItem(Icons.person, 'Profile', 4, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        // Handle other navigation items
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.secondary : AppColors.textSecondary,
                size: 24,
              ),
              if (isActive)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.navLabel.copyWith(
              color: isActive ? AppColors.secondary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
