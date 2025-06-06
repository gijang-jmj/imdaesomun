import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';
import 'package:imdaesomun/src/data/models/file.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/providers/user_provider.dart';

class DevTools extends ConsumerWidget {
  const DevTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final fcmToken = ref.watch(fcmTokenProvider);

    const testNotice = Notice(
      id: "gh63626",
      seq: "63626",
      no: 497,
      title: "25년 매입임대주택 입주자 모집공고(자격완화, 주택목록 게시)",
      department: "매입임대관리부",
      regDate: 1747958400000,
      hits: 3312,
      corporation: "gh",
      files: [
        File(
          fileName: "1. 매입임대 자격완화 모집공고문(2025.05.23).hwp",
          fileLink:
              "https://gh.or.kr/synap/result/zBiNCWydESZpTSQsUFXjhPDQiS.view.xhtml",
          // fileId: "79675",
        ),
      ],
      contents: [],
      link:
          "https://gh.or.kr/gh/announcement-of-salerental001.do?mode=view&articleNo=63626",
    );

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Dev Tools', style: TextStyle(fontSize: 20)),
            Text('ENV : ${dotenv.get('ENV')}'),
            Text('UID : ${user?.uid ?? 'null'}'),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(logProvider.notifier)
                            .log('[Dev Tools]\n\nfcmToken:\n$fcmToken');
                        if (fcmToken != null) {
                          Clipboard.setData(ClipboardData(text: fcmToken));
                        } else {
                          ref
                              .read(globalToastProvider.notifier)
                              .showToast('FCM Token is null');
                        }
                      },
                      child: Text('FCM Token'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(logProvider.notifier)
                            .log('[Dev Tools]\n\nuser:\n$user');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('User Info'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoRow('UID', user?.uid ?? 'null'),
                                  _infoRow('Email', user?.email ?? 'null'),
                                  _infoRow('Name', user?.displayName ?? 'null'),
                                  _infoRow(
                                    'Phone',
                                    user?.phoneNumber ?? 'null',
                                  ),
                                  _infoRow(
                                    'PhotoURL',
                                    user?.photoURL ?? 'null',
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('닫기'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('User Info'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                        context.push(
                          '${RouterPathConstant.notice.path}/${testNotice.id}',
                        );
                      },
                      child: Text('Notice Detail Page'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                        context.push(
                          RouterPathConstant.documentViewer.path,
                          extra: testNotice.files.first,
                        );
                      },
                      child: Text('Document Viewer'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.pop();
                        context.push(RouterPathConstant.log.path);
                      },
                      child: Text('Log Page'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final TextEditingController toastTextController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('토스트 메시지 입력'),
                              content: TextField(
                                controller: toastTextController,
                                decoration: InputDecoration(
                                  hintText: '표시할 토스트 메시지를 입력하세요',
                                ),
                                maxLines: 2,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                    if (toastTextController.text.isNotEmpty) {
                                      context.pop();
                                      ref
                                          .read(globalToastProvider.notifier)
                                          .showToast(toastTextController.text);
                                    }
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Toast Test'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
