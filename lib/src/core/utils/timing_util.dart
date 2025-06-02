import 'dart:async';

typedef TimingCallback = void Function();

class _DebounceOperation {
  TimingCallback callback;
  Timer timer;
  _DebounceOperation(this.callback, this.timer);
}

class Debounce {
  static final Map<String, _DebounceOperation> _operations = {};

  static void call(String tag, Duration duration, TimingCallback onExecute) {
    if (duration == Duration.zero) {
      _operations[tag]?.timer.cancel();
      _operations.remove(tag);
      onExecute();
      return;
    }

    _operations[tag]?.timer.cancel();

    _operations[tag] = _DebounceOperation(
      onExecute,
      Timer(duration, () {
        _operations[tag]?.timer.cancel();
        _operations.remove(tag);
        onExecute();
      }),
    );
  }
}

class _ThrottleOperation {
  TimingCallback callback;
  Timer timer;
  _ThrottleOperation(this.callback, this.timer);
}

class Throttle {
  static final Map<String, _ThrottleOperation> _operations = {};

  static void call(
    String tag,
    Duration duration,
    TimingCallback onExecute, {
    bool leading = true,
    bool trailing = false,
  }) {
    if (duration == Duration.zero) {
      _operations[tag]?.timer.cancel();
      _operations.remove(tag);
      onExecute();
      return;
    }

    final operation = _operations[tag];

    if (operation == null) {
      if (leading) {
        onExecute();
      }

      _operations[tag] = _ThrottleOperation(
        onExecute,
        Timer(duration, () {
          if (trailing) {
            onExecute();
          }
          _operations.remove(tag);
        }),
      );
    }
  }
}
