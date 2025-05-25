import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imdaesomun/src/data/models/file.dart';
import 'package:imdaesomun/src/ui/components/app_bar/app_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewer extends StatelessWidget {
  final File file;

  const DocumentViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final WebViewController controller;
    final Uri uri = Uri.parse(file.fileLink);
    final String userAgent =
        'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1';

    if (file.fileId != null && file.fileId!.isNotEmpty) {
      final Uint8List body = Uint8List.fromList(
        utf8.encode('attachNo=${file.fileId}'),
      );
      controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setUserAgent(userAgent)
            ..loadRequest(
              uri,
              method: LoadRequestMethod.post,
              headers: <String, String>{
                'Content-Type': 'application/x-www-form-urlencoded',
              },
              body: body,
            );
    } else {
      controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setUserAgent(userAgent)
            ..loadRequest(uri);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar(title: const Text('문서 뷰어')),
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
