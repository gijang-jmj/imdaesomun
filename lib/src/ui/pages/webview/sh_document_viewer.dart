import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShDocumentViewer extends StatelessWidget {
  final String url;

  const ShDocumentViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.parse(url);
    final WebViewController controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(uri);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
