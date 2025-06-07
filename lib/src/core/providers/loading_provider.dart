import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalLoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void start() {
    state = true;
  }

  void finish() {
    state = false;
  }
}

final globalLoadingProvider =
    NotifierProvider<GlobalLoadingNotifier, bool>(GlobalLoadingNotifier.new);
