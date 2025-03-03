import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  // Public key for client-side operations
  static const _publicKey = 'public_2I/SucQp1yQYJ0o2dRJ43XHnm+8=';

  // Private key for server-side operations (you should move this to server-side)
  static const _privateKey = 'private_BG5FIng1FlYXU9DDh6rIhCYEJss=';

  static const _urlEndpoint = 'https://ik.imagekit.io/zux0gsifx';
  static const _uploadUrl = 'https://upload.imagekit.io/api/v1/files/upload';

  static Map<String, String> _generateAuthParams() {
    final token = const Uuid().v4();
    final expire =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000 + 2400).toString();

    final hmac = Hmac(sha1, utf8.encode(_privateKey));
    final digest = hmac.convert(utf8.encode(token + expire));
    final signature = digest.toString();

    return {
      'token': token,
      'expire': expire,
      'signature': signature,
      'publicKey': _publicKey,
    };
  }

  static Future<String> uploadVideo(dynamic videoFile, String caption) async {
    try {
      final bytes = await videoFile.readAsBytes();
      final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';

      final authParams = _generateAuthParams();

      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ),
      );

      request.fields.addAll({
        'fileName': fileName,
        'useUniqueFileName': 'true',
        'folder': '/videos',
        'tags': 'video,talk',
        'caption': caption,
        ...authParams,
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Upload failed: ${response.body}');
      }

      final jsonResponse = json.decode(response.body);
      final url = jsonResponse['url'];

      return url;
    } catch (e) {
      print('Error uploading video: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getVideos() async {
    try {
      final url = Uri.parse('https://api.imagekit.io/v1/files');

      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Basic ${base64.encode(utf8.encode('private_BG5FIng1FlYXU9DDh6rIhCYEJss=:'))}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch videos');
      }

      final List<dynamic> data = json.decode(response.body);

      final videos = data
          .where((file) =>
              file['fileType'] == 'non-image' &&
              (file['filePath'] as String).startsWith('/videos/'))
          .toList();

      return videos
          .map<Map<String, dynamic>>((file) => {
                'id': file['fileId'],
                'url': file['url'],
                'caption': file['caption'] ?? '',
                'createdAt': file['createdAt'],
              })
          .toList();
    } catch (e) {
      print('Error getting videos: $e');
      rethrow;
    }
  }
}
