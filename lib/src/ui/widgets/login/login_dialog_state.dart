import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_dialog_state.freezed.dart';
part 'login_dialog_state.g.dart';

@freezed
abstract class LoginDialogState with _$LoginDialogState {
  const factory LoginDialogState({
    required bool obscure,
    required String email,
    required String password,
  }) = _LoginDialogState;

  factory LoginDialogState.fromJson(Map<String, dynamic> json) =>
      _$LoginDialogStateFromJson(json);
}
