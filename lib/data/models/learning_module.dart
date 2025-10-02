// Learning Module Models
// Data models for AI-generated learning content

class LearningModule {
  final String id;
  final String title;
  final String description;
  final List<LearningItem> items;
  final DateTime? createdAt;

  LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
    this.createdAt,
  });

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from JSON response
  factory LearningModule.fromJson(Map<String, dynamic> json) {
    return LearningModule(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => LearningItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  @override
  String toString() {
    return 'LearningModule(id: $id, title: $title, description: $description, items: ${items.length} items)';
  }
}

class LearningItem {
  final int id;
  final String title;
  final String content;
  final String? imageURL;

  LearningItem({
    required this.id,
    required this.title,
    required this.content,
    this.imageURL,
  });

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageURL': imageURL,
    };
  }

  // Create from JSON response
  factory LearningItem.fromJson(Map<String, dynamic> json) {
    return LearningItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageURL: json['imageURL'],
    );
  }

  @override
  String toString() {
    return 'LearningItem(id: $id, title: $title, content: ${content.length} chars, imageURL: $imageURL)';
  }
}
