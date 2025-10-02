import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Practice Wellness',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity indicator
              const Text(
                'activity #1',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              
              // Recommended for you section
              _buildSection(
                title: 'Recommended for you:',
                cards: [
                  _buildContentCard(
                    title: 'Guided medication',
                    type: ContentType.guidedAudio,
                    image: _buildPlaceholderImage(
                      'Lake sunset with tree silhouette',
                      const Color(0xFFFF6B9D),
                    ),
                  ),
                  _buildContentCard(
                    title: 'Understanding Grief',
                    type: ContentType.article,
                    image: _buildPlaceholderImage(
                      'Green hillside with purple flowers and rainbow',
                      const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Mindfulness section
              _buildSection(
                title: 'Mindfulness:',
                cards: [
                  _buildContentCard(
                    title: 'Breathing Exercise',
                    type: ContentType.guidedAudio,
                    image: _buildPlaceholderImage(
                      'Pink and white wildflowers',
                      const Color(0xFFFFB6C1),
                    ),
                  ),
                  _buildContentCard(
                    title: 'Body Scan Squeeze',
                    type: ContentType.guidedAudio,
                    image: _buildPlaceholderImage(
                      'Waterfall cascading down mossy cliff',
                      const Color(0xFF4CAF50),
                    ),
                    isLocked: true,
                    isStarred: true,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Self-Alignment section
              _buildSection(
                title: 'Self-Alignment:',
                cards: [
                  _buildContentCard(
                    title: 'Personal Growth Quiz',
                    type: ContentType.quiz,
                    image: _buildPlaceholderImage(
                      'Rolling hills with pink cloud-like flora',
                      const Color(0xFFFFB6C1),
                    ),
                  ),
                  _buildContentCard(
                    title: 'Coming Soon',
                    type: ContentType.article,
                    image: _buildPlaceholderImage(
                      'Placeholder for future content',
                      const Color(0xFFE0E0E0),
                    ),
                    isEmpty: true,
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> cards,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: cards.map((card) => 
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: card,
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildContentCard({
    required String title,
    required ContentType type,
    required Widget image,
    bool isLocked = false,
    bool isStarred = false,
    bool isEmpty = false,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          if (!isLocked && !isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening $title...')),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isEmpty ? Colors.grey[100] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEmpty ? Colors.grey[300]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with overlay icons
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: image,
                  ),
                  // Content type icon
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildContentTypeIcon(type),
                  ),
                  // Lock icon
                  if (isLocked)
                    const Positioned(
                      bottom: 8,
                      left: 8,
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  // Star icon
                  if (isStarred)
                    const Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                ],
              ),
              // Title and arrow
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    if (!isEmpty)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey,
                      ),
                  ],
                ),
              ),
            ],
          ),
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
        color = Colors.blue;
        break;
      case ContentType.article:
        icon = Icons.article;
        color = Colors.green;
        break;
      case ContentType.quiz:
        icon = Icons.quiz;
        color = Colors.purple;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildPlaceholderImage(String description, Color color) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                description,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
          _buildNavItem(Icons.public, 'Community', 2, true),
          _buildNavItem(Icons.military_tech, 'Badges', 3, false),
          _buildNavItem(Icons.person, 'Profile', 4, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isActive) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          if (index == 0) {
            Navigator.pop(context);
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
                  color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
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
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ContentType {
  guidedAudio,
  article,
  quiz,
}
