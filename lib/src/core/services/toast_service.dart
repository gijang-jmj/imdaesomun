import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/toast.dart';

class GlobalToastNotifier extends Notifier<Toast> {
  Timer? _timer;

  @override
  Toast build() {
    return Toast(message: '');
  }

  void showToast(String message, {int durationInSeconds = 2}) {
    _timer?.cancel();

    state = Toast(
      isVisible: true,
      message: message,
      durationInSeconds: durationInSeconds,
    );

    _timer = Timer(Duration(seconds: durationInSeconds), () {
      hideToast();
    });
  }

  void hideToast() {
    state = state.copyWith(isVisible: false);
  }
}

final globalToastProvider = NotifierProvider<GlobalToastNotifier, Toast>(
  GlobalToastNotifier.new,
);
