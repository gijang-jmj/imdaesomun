import 'package:freezed_annotation/freezed_annotation.dart';

part 'file.freezed.dart';
part 'file.g.dart';

@freezed
abstract class File with _$File {
  const factory File({
    required String fileName,
    required String fileLink,
    String? fileId,
  }) = _File;

  factory File.fromJson(Map<String, dynamic> json) => _$FileFromJson(json);
}
