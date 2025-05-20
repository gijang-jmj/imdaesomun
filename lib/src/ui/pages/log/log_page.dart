import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/log_entry.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/core/theme/app_text_style.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:intl/intl.dart';

class LogPage extends ConsumerWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('로그', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => ref.read(logProvider.notifier).clearLogs(),
            tooltip: '로그 삭제',
          ),
        ],
      ),
      body: logs.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Text(
                '로그가 없습니다.',
                style: AppTextStyle.body1.copyWith(color: Colors.white),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: logs.length,
            separatorBuilder:
                (context, index) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final log = logs[index];
              return LogEntryWidget(log: log);
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('$error')),
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
      ),
    );
  }
}

class LogEntryWidget extends StatelessWidget {
  final LogEntry log;

  const LogEntryWidget({super.key, required this.log});

  Color _getTypeColor() {
    switch (log.type) {
      case LogType.error:
        return Colors.red;
      case LogType.warning:
        return Colors.orange;
      case LogType.info:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
                  '${dateFormatter.format(log.timestamp)} [${log.type.name}]\n',
              style: TextStyle(
                color: _getTypeColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: log.message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
