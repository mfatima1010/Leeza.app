class VideoStory {
  final String id;
  final String userId;
  final String videoUrl;
  final String caption;
  final DateTime timestamp;
  final int likes;
  final int views;
  final List<String> comments;

  VideoStory({
    required this.id,
    required this.userId,
    required this.videoUrl,
    required this.caption,
    required this.timestamp,
    this.likes = 0,
    this.views = 0,
    this.comments = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'videoUrl': videoUrl,
        'caption': caption,
        'timestamp': timestamp.toIso8601String(),
        'likes': likes,
        'views': views,
        'comments': comments,
      };

  factory VideoStory.fromJson(Map<String, dynamic> json) => VideoStory(
        id: json['id'],
        userId: json['userId'],
        videoUrl: json['videoUrl'],
        caption: json['caption'],
        timestamp: DateTime.parse(json['timestamp']),
        likes: json['likes'],
        views: json['views'],
        comments: List<String>.from(json['comments']),
      );
}
