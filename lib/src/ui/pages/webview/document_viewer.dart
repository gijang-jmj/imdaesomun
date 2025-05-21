import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imdaesomun/src/data/models/file.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewer extends StatelessWidget {
  final File file;

  const DocumentViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final WebViewController controller;
    final Uri uri = Uri.parse(file.fileLink);

    if (file.fileId != null && file.fileId!.isNotEmpty) {
      final Uint8List body = Uint8List.fromList(
        utf8.encode('attachNo=${file.fileId}'),
      );
      controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
            ..loadRequest(uri);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
