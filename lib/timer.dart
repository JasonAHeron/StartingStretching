import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

class CountdownTimer extends Stream<CountdownTimer> {
  static const Duration _ONE_SECOND = Duration(seconds: 1);
  static const _THRESHOLD_MS = 4;

  final Stopwatch _stopwatch;
  final StreamController<CountdownTimer> _controller;

  bool _paused = false;
  Duration totalDuration;
  Timer _timer;

  CountdownTimer(this.totalDuration)
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

  String get remainingToString => _timeString(remaining);

  String get totalDurationToString => _timeString(totalDuration);

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
    totalDuration -= duration;
  }

  _tick(Timer timer) {
    var t = remaining;
    _controller.add(this);
    // timers may have a 4ms resolution
    if (t.inMilliseconds < _THRESHOLD_MS) {
      cancel();
    }
  }

  String _timeString(Duration duration) {
    return duration.toString().substring(2).split('.')[0];
  }
}

class RestTimer extends StatefulWidget {
  @override
  _RestTimerState createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  CountdownTimer timer = CountdownTimer(Duration(minutes: 1));
  bool paused = false;

  _togglePause() {
    timer.togglePause();
    setState(() {
      paused = !paused;
    });
  }

  _restart() {
    timer.cancel();
    setState(() {
      timer = CountdownTimer(Duration(minutes: 1));
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
              builder: (context, AsyncSnapshot<CountdownTimer> snapshot) {
                return CircularPercentIndicator(
                  radius: 200.0,
                  lineWidth: 7.0,
                  percent: snapshot.data.percentRemaining,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapshot.data.remainingToString,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot.data.totalDurationToString,
                      ),
                    ],
                  ),
                  progressColor: Colors.green,
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _restart,
                child: Text("Restart"),
              ),
              RaisedButton(
                onPressed: timer == null ? null : _togglePause,
                child: Text(!paused ? "Pause" : "Unpause"),
              ),
              RaisedButton(
                onPressed: () {
                  timer.addTime(Duration(seconds: 30));
                },
                child: Text("+ 30s"),
              ),
              RaisedButton(
                onPressed: () {
                  timer.subtractTime(Duration(seconds: 30));
                },
                child: Text("- 30s"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
