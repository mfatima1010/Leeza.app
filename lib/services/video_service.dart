import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/video_story.dart';

class VideoService {
  static const String baseUrl = 'YOUR_API_ENDPOINT';

  Future<String> uploadVideo(File videoFile, String caption) async {
    // TODO: Implement actual video upload
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return 'https://example.com/mock-video-url.mp4';
  }

  Future<List<VideoStory>> getVideoStories() async {
    // TODO: Implement actual video fetching
    await Future.delayed(Duration(seconds: 1));
    return [
      VideoStory(
        id: '1',
        userId: 'user1',
        videoUrl: 'https://example.com/video1.mp4',
        caption: 'Sample Video 1',
        timestamp: DateTime.now(),
      ),
      VideoStory(
        id: '2',
        userId: 'user2',
        videoUrl: 'https://example.com/video2.mp4',
        caption: 'Sample Video 2',
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<List<VideoStory>> getUserVideos(String userId) async {
    // TODO: Implement actual user videos fetching
    await Future.delayed(Duration(seconds: 1));
    return [
      VideoStory(
        id: '1',
        userId: userId,
        videoUrl: 'https://example.com/user-video1.mp4',
        caption: 'My Video 1',
        timestamp: DateTime.now(),
      ),
    ];
  }
}
