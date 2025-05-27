import 'dart:async';
import 'dart:convert';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/core/services/log_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogService {
  static const String _logsKey = 'app_logs';

  static Future<List<LogEntry>> getLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? logsJson = prefs.getString(_logsKey);

    if (logsJson == null) return [];

    List<dynamic> decodedLogs = jsonDecode(logsJson);
    final logs = decodedLogs.map((log) => LogEntry.fromJson(log)).toList();

    // 최신순으로 timestamp 기준 정렬
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  static Future<void> log(String message, {LogType type = LogType.info}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logs = await getLogs();

      logs.add(
        LogEntry(message: message, type: type, timestamp: DateTime.now()),
      );

      // Keep only the last 100 logs to prevent excessive storage
      if (logs.length > 100) {
        logs.removeAt(0);
      }

      await prefs.setString(
        _logsKey,
        jsonEncode(logs.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Logging error: $e');
    }
  }

  static Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_logsKey);
  }
}

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

  Future<void> log(String message, {LogType type = LogType.info}) async {
    await LogService.log(message, type: type);
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
