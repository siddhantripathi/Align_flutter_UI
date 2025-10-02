import 'mood_option.dart';

// Check-in Data Model
// Comprehensive model for storing check-in session data

class CheckinData {
  final MoodOption selectedMood;
  final List<String> selectedMoodTags;
  final List<String> selectedWellness;
  final List<String> selectedSocial;
  final String? additionalNotes;
  final List<String> photoUrls;
  final String? voiceMemoUrl;
  final DateTime timestamp;

  CheckinData({
    required this.selectedMood,
    required this.selectedMoodTags,
    required this.selectedWellness,
    required this.selectedSocial,
    this.additionalNotes,
    this.photoUrls = const [],
    this.voiceMemoUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    return {
      'selectedMood': selectedMood.toJson(),
      'selectedMoodTags': selectedMoodTags,
      'selectedWellness': selectedWellness,
      'selectedSocial': selectedSocial,
      'additionalNotes': additionalNotes,
      'photoUrls': photoUrls,
      'voiceMemoUrl': voiceMemoUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON response
  factory CheckinData.fromJson(Map<String, dynamic> json) {
    return CheckinData(
      selectedMood: MoodOption.fromJson(json['selectedMood'] ?? {}),
      selectedMoodTags: List<String>.from(json['selectedMoodTags'] ?? []),
      selectedWellness: List<String>.from(json['selectedWellness'] ?? []),
      selectedSocial: List<String>.from(json['selectedSocial'] ?? []),
      additionalNotes: json['additionalNotes'],
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      voiceMemoUrl: json['voiceMemoUrl'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Create a copy with updated fields
  CheckinData copyWith({
    MoodOption? selectedMood,
    List<String>? selectedMoodTags,
    List<String>? selectedWellness,
    List<String>? selectedSocial,
    String? additionalNotes,
    List<String>? photoUrls,
    String? voiceMemoUrl,
    DateTime? timestamp,
  }) {
    return CheckinData(
      selectedMood: selectedMood ?? this.selectedMood,
      selectedMoodTags: selectedMoodTags ?? this.selectedMoodTags,
      selectedWellness: selectedWellness ?? this.selectedWellness,
      selectedSocial: selectedSocial ?? this.selectedSocial,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      photoUrls: photoUrls ?? this.photoUrls,
      voiceMemoUrl: voiceMemoUrl ?? this.voiceMemoUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'CheckinData(selectedMood: $selectedMood, selectedMoodTags: $selectedMoodTags, selectedWellness: $selectedWellness, selectedSocial: $selectedSocial, additionalNotes: $additionalNotes, photoUrls: $photoUrls, voiceMemoUrl: $voiceMemoUrl, timestamp: $timestamp)';
  }
}
