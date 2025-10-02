// Wellness Module Models
// Data models for wellness content from Firebase

enum ContentType {
  guidedAudio,
  article,
  quiz,
}

enum WellnessCategory {
  recommended,
  mindfulness,
  selfAlignment,
}

class WellnessModule {
  final String id;
  final String title;
  final String description;
  final ContentType contentType;
  final WellnessCategory category;
  final String? imageUrl;
  final int durationMinutes;
  final bool isLocked;
  final bool isStarred;
  final bool isEmpty;
  final List<WellnessActivity> activities;

  WellnessModule({
    required this.id,
    required this.title,
    required this.description,
    required this.contentType,
    required this.category,
    this.imageUrl,
    this.durationMinutes = 0,
    this.isLocked = false,
    this.isStarred = false,
    this.isEmpty = false,
    this.activities = const [],
  });

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'contentType': contentType.name,
      'category': category.name,
      'imageUrl': imageUrl,
      'durationMinutes': durationMinutes,
      'isLocked': isLocked,
      'isStarred': isStarred,
      'isEmpty': isEmpty,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }

  // Create from Firebase JSON
  factory WellnessModule.fromJson(Map<String, dynamic> json) {
    return WellnessModule(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      contentType: ContentType.values.firstWhere(
        (e) => e.name == json['contentType'],
        orElse: () => ContentType.article,
      ),
      category: WellnessCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => WellnessCategory.recommended,
      ),
      imageUrl: json['imageUrl'],
      durationMinutes: json['durationMinutes'] ?? 0,
      isLocked: json['isLocked'] ?? false,
      isStarred: json['isStarred'] ?? false,
      isEmpty: json['isEmpty'] ?? false,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((a) => WellnessActivity.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  @override
  String toString() {
    return 'WellnessModule(id: $id, title: $title, category: $category, contentType: $contentType)';
  }
}

class WellnessActivity {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String? audioUrl;
  final String? videoUrl;
  final String? contentUrl;

  WellnessActivity({
    required this.id,
    required this.title,
    required this.description,
    this.durationMinutes = 0,
    this.audioUrl,
    this.videoUrl,
    this.contentUrl,
  });

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'contentUrl': contentUrl,
    };
  }

  // Create from Firebase JSON
  factory WellnessActivity.fromJson(Map<String, dynamic> json) {
    return WellnessActivity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      audioUrl: json['audioUrl'],
      videoUrl: json['videoUrl'],
      contentUrl: json['contentUrl'],
    );
  }

  @override
  String toString() {
    return 'WellnessActivity(id: $id, title: $title, duration: ${durationMinutes}min)';
  }
}
