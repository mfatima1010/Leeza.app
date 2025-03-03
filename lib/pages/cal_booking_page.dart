import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalBookingPage extends StatefulWidget {
  final String url;
  const CalBookingPage({Key? key, required this.url}) : super(key: key);

  @override
  State<CalBookingPage> createState() => _CalBookingPageState();
}

class _CalBookingPageState extends State<CalBookingPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Instantiate the WebViewController and configure it.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optionally update a loading indicator.
          },
          onPageStarted: (String url) {
            // Handle when page loading starts.
          },
          onPageFinished: (String url) {
            // Handle when page loading finishes.
          },
          onNavigationRequest: (NavigationRequest request) {
            // Optionally, prevent navigation to certain URLs.
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            // Handle errors if necessary.
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
