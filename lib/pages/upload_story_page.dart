import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';
import '../constants/app_color.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/video_story.dart';
import '../services/video_service.dart';
import '../services/storage_service.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';

/// This is a placeholder page for uploading or recording a video.
/// In a complete implementation, you would integrate video recording/upload functionality,
/// allow users to enter a caption, and then upload the video (e.g., to Google Drive).
class UploadStoryPage extends StatefulWidget {
  const UploadStoryPage({Key? key}) : super(key: key);

  @override
  State<UploadStoryPage> createState() => _UploadStoryPageState();
}

class _UploadStoryPageState extends State<UploadStoryPage> {
  File? _videoFile;
  final _captionController = TextEditingController();
  VideoPlayerController? _controller;
  bool _isUploading = false;

  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: source);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    if (_videoFile != null) {
      _controller = VideoPlayerController.file(_videoFile!);
      await _controller!.initialize();
      await _controller!.setLooping(true);
      setState(() {});
    }
  }

  Future<bool> uploadVideoToImageKit(String videoPath) async {
    try {
      // First check file size
      final file = File(videoPath);
      final fileSize = await file.length();
      if (fileSize > 25 * 1024 * 1024) {
        // 25MB limit
        print('File too large: ${fileSize / (1024 * 1024)}MB');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video must be under 25MB')),
        );
        return false;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://upload.imagekit.io/api/v1/files/upload'),
      );

      // Add file with content type
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          videoPath,
          filename: path.basename(videoPath),
          contentType: MediaType('video', 'mp4'),
        ),
      );

      // Add required parameters
      request.fields.addAll({
        'publicKey': 'public_2I/SucQp1yQYJ0o2dRJ43XHnm+8=',
        'fileName': 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
        'folder': '/videos',
        'useUniqueFileName': 'true',
      });

      // Add proper authentication headers
      final credentials = 'private_BG5FIng1FlYXU9DDh6rIhCYEJss=:';
      final encodedCredentials = base64Encode(utf8.encode(credentials));

      request.headers.addAll({
        'Authorization': 'Basic $encodedCredentials',
        'X-ImageKit-ID': 'zux0gsifx',
      });

      // Set timeout duration
      final streamedResponse = await request.send().timeout(
        Duration(minutes: 5),
        onTimeout: () {
          throw TimeoutException('Upload took too long');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final videoUrl = responseData['url'];
        print('Video URL: $videoUrl');

        // TODO: Implement video saving in VideoService
        // For now, just return success
        return true;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        print('Error response: ${response.body}');
        return false;
      }
    } on TimeoutException {
      print('Upload timed out');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload timed out. Please try again.')),
      );
      return false;
    } catch (e) {
      print('Error uploading video: $e');
      return false;
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final success = await uploadVideoToImageKit(_videoFile!.path);

      if (success) {
        // Handle successful upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully!')),
        );
      } else {
        // Handle upload failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload video')),
        );
      }
    } catch (e) {
      print('Error during upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading video')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Your Story'),
        elevation: 0,
        actions: [
          if (_videoFile != null)
            TextButton(
              onPressed: _isUploading ? null : _uploadVideo,
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Share',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
            ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF9F3E3),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF9F3E3),
                ),
              ),
            ),
            // Main content
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_videoFile == null) ...[
                        Icon(
                          Icons.movie_creation,
                          size: 80,
                          color: Color(0xFFCB6BE5).withAlpha(204),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Color(0xFFCB6BE5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Autism and ADHD is not something to be fixed, but need to be embraced",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFCB6BE5),
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          'Create Your Story',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Color(0xFFF5B400),
                                  Color(0xFFFFD699),
                                ],
                              ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Share your moments with your friends and family',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFF5B400),
                                Color(0xFFFFD699),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primary.withAlpha(40),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => _pickVideo(ImageSource.gallery),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.photo_library, size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  'Choose from Gallery',
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFD699),
                                Color(0xFFF5B400),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.primary.withAlpha(40),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => _pickVideo(ImageSource.camera),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.videocam, size: 28),
                                const SizedBox(width: 12),
                                Text(
                                  'Record a Video',
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (_videoFile != null && _controller != null) ...[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _captionController,
                          decoration: InputDecoration(
                            labelText: 'Write a caption...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: Colors.grey.withAlpha(25),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFF5B400),
                                Color(0xFFFFD699),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed:
                                _isUploading ? null : () => _uploadVideo(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: _isUploading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Share Story',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
