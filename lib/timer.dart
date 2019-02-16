import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CountdownTimer extends Stream<CountdownTimer> {
  static const Duration _ONE_SECOND = Duration(seconds: 1);
  static const _THRESHOLD_MS = 4;

  final Stopwatch _stopwatch;
  final AudioPlayer _audioPlayer;
  final AudioCache _audioCache;
  final StreamController<CountdownTimer> _controller;

  bool _paused = false;
  Duration totalDuration;
  Timer _timer;

  CountdownTimer(this.totalDuration)
      : _stopwatch = Stopwatch(),
        _audioPlayer = AudioPlayer(),
        _audioCache = AudioCache(),
        _controller = StreamController<CountdownTimer>.broadcast(sync: true) {
    _timer = new Timer.periodic(_ONE_SECOND, _tick);
    _stopwatch.start();
  }

  StreamSubscription<CountdownTimer> listen(void onData(CountdownTimer event),
          {Function onError, void onDone(), bool cancelOnError}) =>
      _controller.stream.listen(onData, onError: onError, onDone: onDone);

  Duration get elapsed => _stopwatch.elapsed;

  Duration get remaining => totalDuration - _stopwatch.elapsed;

  String get remainingToString => timeString(remaining);

  String get totalDurationToString => timeString(totalDuration);

  double get percentRemaining => remaining.inSeconds / totalDuration.inSeconds;

  bool get isRunning => _stopwatch.isRunning;

  cancel() {
    _stopwatch.stop();
    _timer.cancel();
    _controller.close();
  }

  togglePause() {
    if (_paused) {
      _stopwatch.start();
      _paused = false;
    } else {
      _stopwatch.stop();
      _paused = true;
    }
  }

  addTime(Duration duration) {
    totalDuration += duration;
  }

  subtractTime(Duration duration) {
    if (totalDuration - duration > Duration()) {
      totalDuration -= duration;
    }
  }

  _playAlarm() async {
    await _audioCache.play('alarm.mp3');
  }

  _tick(Timer timer) {
    var t = remaining;
    _controller.add(this);
    // timers may have a 4ms resolution
    if (t.inMilliseconds < _THRESHOLD_MS) {
      _playAlarm();
      cancel();
    }
  }

  static String timeString(Duration duration) {
    return duration.toString().substring(2).split('.')[0];
  }
}

class RestTimer extends StatefulWidget {
  final Duration duration;

  @override
  _RestTimerState createState() => _RestTimerState(this.duration);

  RestTimer(this.duration);
}

class _RestTimerState extends State<RestTimer> {
  CountdownTimer timer;
  Duration duration;
  bool paused = false;

  _RestTimerState(this.duration) {
    timer = CountdownTimer(duration);
  }

  @override
  @mustCallSuper
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  _togglePause() {
    timer.togglePause();
    setState(() {
      paused = !paused;
    });
  }

  _restart() {
    timer.cancel();
    setState(() {
      timer = CountdownTimer(duration);
      paused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(
            stream: timer,
            builder: (context, snapshot) {
              return CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 7.0,
                percent:
                    snapshot.data == null ? 1 : snapshot.data.percentRemaining,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.data == null
                          ? CountdownTimer.timeString(duration)
                          : snapshot.data.remainingToString,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      snapshot.data == null
                          ? CountdownTimer.timeString(duration)
                          : snapshot.data.totalDurationToString,
                    ),
                  ],
                ),
                progressColor: Colors.green,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Theme.of(context).buttonColor,
                minWidth: 45,
                padding: EdgeInsets.all(1),
                child: Icon(Icons.restore),
                onPressed: _restart,
              ),
              MaterialButton(
                color: Theme.of(context).buttonColor,
                minWidth: 45,
                padding: EdgeInsets.all(1),
                onPressed: timer == null ? null : _togglePause,
                child: paused ? Icon(Icons.play_arrow) : Icon(Icons.pause),
              ),
              MaterialButton(
                color: Theme.of(context).buttonColor,
                minWidth: 45,
                padding: EdgeInsets.all(1),
                onPressed: () {
                  timer.addTime(Duration(seconds: 30));
                },
                child: Text("+30s"),
              ),
              MaterialButton(
                color: Theme.of(context).buttonColor,
                minWidth: 45,
                padding: EdgeInsets.all(1),
                onPressed: () {
                  timer.subtractTime(Duration(seconds: 30));
                },
                child: Text("-30s"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
