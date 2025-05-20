import 'package:freezed_annotation/freezed_annotation.dart';

part 'toast.freezed.dart';
part 'toast.g.dart';

@freezed
abstract class Toast with _$Toast {
  factory Toast({
    required String message,
    @Default(false) bool isVisible,
    @Default(3) int durationInSeconds,
  }) = _Toast;

  factory Toast.fromJson(Map<String, dynamic> json) => _$ToastFromJson(json);
}
