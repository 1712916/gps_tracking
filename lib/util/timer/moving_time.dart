import 'dart:async';

import 'package:gps_speed/data/moving_control.dart';
import 'package:gps_speed/feature/tracking_speed/cubit/tracking_cubit.dart';

import 'custom_timer.dart';

class MovingTime implements MovingControl {
  final CustomTimer _timer = CustomTimer();

  late final Stream<Duration> _timerStream = _timer.stream.asBroadcastStream();

  Stream<Duration> get timerStream => _timerStream;

  Duration get currentTime => _timer.currentTime;

  void cancel() {
    _timer.cancel();
  }

  @override
  void resume() {
    _timer.stop();
  }

  @override
  void start() {
    _timer.start();
  }

  @override
  void stop() {
    _timer.stop();
  }

  @override
  void pause() {
    _timer.stop();
  }

  @override
  void reset() {
    _timer.reset();
  }
}
