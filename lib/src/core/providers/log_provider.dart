import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:imdaesomun/src/data/models/log_entry.dart';

class LogNotifier extends AutoDisposeAsyncNotifier<List<LogEntry>> {
  Future<List<LogEntry>> _getLogs() async {
    return await LogService.getLogs();
  }

  @override
  FutureOr<List<LogEntry>> build() async {
    return _getLogs();
  }

  Future<void> _updateLogs() async {
    try {
      state = const AsyncLoading();
      final logs = await _getLogs();
      state = AsyncData(logs);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  Future<void> log(
    String message, {
    LogType type = LogType.info,
    String? error,
    StackTrace? stackTrace,
  }) async {
    await LogService.log(
      message,
      type: type,
      error: error,
      stackTrace: stackTrace,
    );
  }

  Future<void> clearLogs() async {
    await LogService.clearLogs();
    _updateLogs();
  }
}

final logProvider =
    AsyncNotifierProvider.autoDispose<LogNotifier, List<LogEntry>>(
      LogNotifier.new,
    );
