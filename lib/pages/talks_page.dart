import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/storage_service.dart';
import 'upload_story_page.dart';

/// A model representing a video reel.
class VideoReel {
  final String videoUrl; // The URL of the video (from Google Drive)
  final String caption;
  final int likes;
  final int comments;
  VideoPlayerController? controller;

  VideoReel({
    required this.videoUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    this.controller,
  });
}

/// The TalksPage displays a vertical list of video reels (like Instagram/TikTok feed)
/// along with an "Upload Your Story" button in the AppBar.
class TalksPage extends StatefulWidget {
  const TalksPage({Key? key}) : super(key: key);

  @override
  State<TalksPage> createState() => _TalksPageState();
}

class _TalksPageState extends State<TalksPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<VideoReel> _reels = [];
  late Future<List<Map<String, dynamic>>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  void _loadVideos() {
    _videosFuture = StorageService.getVideos();
    _videosFuture.then((videos) {
      setState(() {
        _reels = videos
            .map((video) => VideoReel(
                  videoUrl: video['url'],
                  caption: video['caption'],
                  likes: 0,
                  comments: 0,
                ))
            .toList();
      });
    });
  }

  // Add this method to refresh videos after upload
  void _refreshVideos() {
    setState(() {
      _loadVideos();
    });
  }

  /// When the share icon is tapped, display a dialog with a shareable link.
  void _shareVideo(String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Share Video"),
          content: Text("Share this link:\n$videoUrl"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  /// Builds a card widget for a single video reel.
  Widget _buildReelCard(VideoReel reel) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for video thumbnail.
          // In a full implementation, you can replace this Container with a video player widget.
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.black12,
                child: Center(
                  child: Icon(Icons.play_circle_outline,
                      size: 64, color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              reel.caption,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${reel.likes}"),
                const SizedBox(width: 16),
                Icon(Icons.comment_outlined, size: 20, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${reel.comments}"),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.grey),
                  onPressed: () => _shareVideo(reel.videoUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Leeza Talks",
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Container(
        color: Colors.black,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _reels.length,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          itemBuilder: (context, index) {
            return AspectRatio(
              aspectRatio: 9 / 16, // Fixed aspect ratio for Reels format
              child: VideoReelWidget(reel: _reels[index]),
            );
          },
        ),
      ),
    );
  }
}

class VideoReelWidget extends StatefulWidget {
  final VideoReel reel;

  const VideoReelWidget({Key? key, required this.reel}) : super(key: key);

  @override
  State<VideoReelWidget> createState() => _VideoReelWidgetState();
}

class _VideoReelWidgetState extends State<VideoReelWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoUrl));
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player (unchanged)
        GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: Container(
            color: Colors.black,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Center(
              child: AspectRatio(
                aspectRatio: 9 / 16, // Fixed aspect ratio for Reels format
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Updated gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
                stops: const [0.7, 1.0], // Gradient starts 70% from the top
              ),
            ),
          ),
        ),

        // Updated caption and actions
        Positioned(
          bottom: 30,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.reel.caption,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Updated right side actions
        Positioned(
          right: 16,
          bottom: 30,
          child: Column(
            children: [
              _buildAnimatedActionButton(
                Icons.favorite,
                widget.reel.likes.toString(),
                isLiked: _isLiked,
                onTap: () => setState(() => _isLiked = !_isLiked),
              ),
              const SizedBox(height: 24),
              _buildAnimatedActionButton(
                Icons.comment_rounded,
                widget.reel.comments.toString(),
              ),
              const SizedBox(height: 24),
              _buildAnimatedActionButton(
                Icons.share_rounded,
                "Share",
                onTap: () => _shareVideo(widget.reel.videoUrl),
              ),
            ],
          ),
        ),

        // Play/Pause indicator
        if (!_isPlaying)
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pause,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedActionButton(
    IconData icon,
    String label, {
    bool isLiked = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLiked ? Colors.red.withOpacity(0.3) : Colors.black26,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isLiked ? Colors.red : Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareVideo(String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Share Video"),
          content: Text("Share this link:\n$videoUrl"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _handleDoubleTap() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }
}
