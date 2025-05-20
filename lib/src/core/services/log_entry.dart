import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imdaesomun/src/core/enums/log_enum.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

@freezed
abstract class LogEntry with _$LogEntry {
  factory LogEntry({
    required String message,
    required LogType type,
    required DateTime timestamp,
  }) = _LogEntry;

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);
}
