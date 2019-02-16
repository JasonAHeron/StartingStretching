import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CountdownTimer extends Stream<CountdownTimer> {
  static const Duration _ONE_SECOND = Duration(seconds: 1);
  static const _THRESHOLD_MS = 4;

  final Stopwatch _stopwatch;
  final StreamController<CountdownTimer> _controller;

  bool _paused = false;
  Function callBack;
  Duration totalDuration;
  Timer _timer;

  CountdownTimer(this.totalDuration, [this.callBack])
      : _stopwatch = Stopwatch(),
        _controller = StreamController<CountdownTimer>.broadcast(sync: true) {
    _timer = new Timer.periodic(_ONE_SECOND, _tick);
    _stopwatch.start();
  }

  StreamSubscription<CountdownTimer> listen(void onData(CountdownTimer event),
          {Function onError, void onDone(), bool cancelOnError}) =>
      _controller.stream.listen(onData, onError: onError, onDone: onDone);

  Duration get elapsed => _stopwatch.elapsed;

  Duration get remaining => totalDuration - _stopwatch.elapsed;

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

  _tick(Timer timer) {
    var t = remaining;
    _controller.add(this);
    // timers may have a 4ms resolution
    if (t.inMilliseconds < _THRESHOLD_MS) {
      if (this.callBack != null) {
        this.callBack();
      }
      cancel();
    }
  }
}

class RestTimer extends StatefulWidget {
  final Duration duration;

  @override
  _RestTimerState createState() => _RestTimerState(this.duration);

  RestTimer(this.duration);

  static String timeString(Duration duration) {
    final secs = duration.inSeconds % 60;
    final secsPadded = secs.toString().padLeft(2, '0');
    return "${duration.inMinutes}:$secsPadded";
  }
}

class _RestTimerState extends State<RestTimer> {
  final AudioCache _audioPlayer = AudioCache();
  final Duration _duration;

  CountdownTimer timer;
  bool paused = false;

  _RestTimerState(this._duration) {
    timer = CountdownTimer(_duration, _playAlarm);
  }

  @override
  @mustCallSuper
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  _playAlarm() async {
    await this._audioPlayer.play('alarm.mp3');
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
      timer = CountdownTimer(_duration, _playAlarm);
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
            builder:
                (BuildContext context, AsyncSnapshot<CountdownTimer> snapshot) {
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
                          ? RestTimer.timeString(_duration)
                          : RestTimer.timeString(snapshot.data.remaining),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      snapshot.data == null
                          ? RestTimer.timeString(_duration)
                          : RestTimer.timeString(snapshot.data.remaining),
                    ),
                  ],
                ),
                progressColor: Theme.of(context).accentColor,
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
