import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';
import 'package:imdaesomun/src/core/services/toast_service.dart';

class DevTools extends ConsumerWidget {
  const DevTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Dev Tools', style: TextStyle(fontSize: 20)),
            Text('ENV : ${dotenv.get('ENV')}'),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                context.pop();
                context.push(RouterPathConstant.log.path);
              },
              child: Text('Log Page'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
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
    );
  }
}
