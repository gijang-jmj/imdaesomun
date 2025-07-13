import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imdaesomun/src/data/models/file.dart';
import 'package:imdaesomun/src/ui/widgets/app_bar/app_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewer extends StatelessWidget {
  final File file;

  const DocumentViewer({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final WebViewController controller;
    final Uri uri = Uri.parse(file.fileLink);
    final String userAgent =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36';

    if (file.fileId != null && file.fileId!.isNotEmpty) {
      final Uint8List body = Uint8List.fromList(
        utf8.encode('attachNo=${file.fileId}'),
      );
      controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setUserAgent(userAgent)
            ..setNavigationDelegate(
              NavigationDelegate(
                onSslAuthError: (request) {
                  if (file.fileLink.contains('bmc.busan.kr')) {
                    request.proceed();
                  } else {
                    request.cancel();
                  }
                },
              ),
            )
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
            ..setNavigationDelegate(
              NavigationDelegate(
                onSslAuthError: (request) {
                  if (file.fileLink.contains('bmc.busan.kr')) {
                    request.proceed();
                  } else {
                    request.cancel();
                  }
                },
              ),
            )
            ..loadRequest(uri);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar(title: const Text('문서 뷰어')),
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
