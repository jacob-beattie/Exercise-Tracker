import 'package:dp_stopwatch/dp_stopwatch.dart';
import 'package:flutter/material.dart';

//This is a stopwatch that counts up.
//Reference: https://pub.dev/packages/dp_stopwatch
class StopWatch {
  //The stopwatch
  static final stopWatch = DPStopwatchViewModel(
    clockTextStyle: const TextStyle(color: Colors.black, fontSize: 40),
  );

  //Start the stopwatch
  void start() {
    stopWatch.start?.call();
  }

  //Stop the stopwatch
  void stop() {
    stopWatch.stop?.call();
  }

  //Get the stopwatch
  DPStopwatchViewModel get() {
    return stopWatch;
  }
}
