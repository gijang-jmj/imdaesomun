import 'dart:async';
import 'dart:convert';
import 'package:imdaesomun/src/core/enums/log_enum.dart';
import 'package:imdaesomun/src/data/models/log_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogService {
  static const String _logsKey = 'app_logs';

  static Future<List<LogEntry>> getLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? logsJson = prefs.getString(_logsKey);

      if (logsJson == null) return [];

      List<dynamic> decodedLogs = jsonDecode(logsJson);
      final logs = decodedLogs.map((log) => LogEntry.fromJson(log)).toList();

      // 최신순으로 timestamp 기준 정렬
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return logs;
    } catch (e) {
      // ignore: avoid_print
      print('Error getting logs: $e');
      return [];
    }
  }

  static Future<void> log(
    String message, {
    LogType type = LogType.info,
    String? error,
    StackTrace? stackTrace,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logs = await getLogs();

      if (error != null || stackTrace != null) {
        message = '$message\n\nError:\n$error\n\nStackTrace:\n$stackTrace';
        type = LogType.error;
      }

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
