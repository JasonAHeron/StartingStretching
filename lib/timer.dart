import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

class CountdownTimer extends Stream<CountdownTimer> {
  static const Duration _ONE_SECOND = Duration(seconds: 1);
  static const _THRESHOLD_MS = 4;

  final Stopwatch _stopwatch;
  final StreamController<CountdownTimer> _controller;

  bool _paused = false;
  Duration _duration;
  Timer _timer;

  CountdownTimer(this._duration)
      : _stopwatch = Stopwatch(),
        _controller = StreamController<CountdownTimer>.broadcast(sync: true) {
    _timer = new Timer.periodic(_ONE_SECOND, _tick);
    _stopwatch.start();
  }

  StreamSubscription<CountdownTimer> listen(void onData(CountdownTimer event),
          {Function onError, void onDone(), bool cancelOnError}) =>
      _controller.stream.listen(onData, onError: onError, onDone: onDone);

  Duration get elapsed => _stopwatch.elapsed;

  Duration get remaining => _duration - _stopwatch.elapsed;

  Duration get totalDuration => _duration;

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
    _duration += duration;
  }

  _tick(Timer timer) {
    var t = remaining;
    _controller.add(this);
    // timers may have a 4ms resolution
    if (t.inMilliseconds < _THRESHOLD_MS) {
      cancel();
    }
  }
}

class RestTimer extends StatefulWidget {
  @override
  _RestTimerState createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> {
  CountdownTimer timer = CountdownTimer(Duration(minutes: 1));

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
                  lineWidth: 5.0,
                  percent: snapshot.data.percentRemaining,
                  center: new Text(snapshot.data.remaining.toString()),
                  progressColor: Colors.green,
                );
              }),
          new RaisedButton(
            onPressed: () {},
            child: Text("Start"),
          ),
          new RaisedButton(
            onPressed: timer == null ? null : timer.togglePause,
            child: Text("Pause"),
          ),
          new RaisedButton(
            onPressed: timer == null
                ? null
                : () {
                    timer.addTime(Duration(seconds: 30));
                  },
            child: Text("Add 30 seconds"),
          ),
        ],
      ),
    );
  }
}
