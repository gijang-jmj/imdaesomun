import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GhDocumentViewer extends StatelessWidget {
  final String attachNo;

  const GhDocumentViewer({super.key, required this.attachNo});

  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.parse('https://gh.or.kr/gh/conv.do');
    final Uint8List body = Uint8List.fromList(
      utf8.encode('attachNo=$attachNo'),
    );
    final WebViewController controller =
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
