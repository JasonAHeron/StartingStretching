import 'package:flutter/material.dart';
import 'package:lift/exercise.dart';

import 'timer.dart';

void main() => runApp(MyApp());

const List<Duration> TIMER_PRESETS = [
  Duration(minutes: 1),
  Duration(minutes: 1, seconds: 15),
  Duration(minutes: 1, seconds: 30),
  Duration(minutes: 2),
  Duration(minutes: 3),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starting Stretching',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Starting Stretching'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  List<Exercise> remainingStretches;

  @override
  void initState() {
    super.initState();
    remainingStretches = new List<Exercise>.from(EXERCISES);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: remainingStretches.length,
        itemBuilder: (context, index) {
          final exercise = remainingStretches[index];
          return Dismissible(
            key: Key(exercise.title),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              // Remove the item from our data source.
              setState(() {
                remainingStretches.removeAt(index);
              });

              // Then show a snackbar!
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("${exercise.title} completed!")));
            },
            background: Container(
              color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.white, size: 80),
                  ),
                ],
              ),
            ),
            child: StretchCard(exercise),
          );
        },
      ),
    );
  }
}

class StretchCard extends StatelessWidget {
  final Exercise exercise;

  StretchCard(this.exercise);

  _showTimer(BuildContext context, String name, Duration duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: new Text(name),
          children: <Widget>[
            RestTimer(duration),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                exercise.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).accentColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Description(Progression.BEGINNER, exercise.progressions),
                Description(Progression.INTERMEDIATE, exercise.progressions),
                Description(Progression.ADVANCED, exercise.progressions),
              ],
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: TIMER_PRESETS
                    .map((duration) => FlatButton(
                          child: Text(RestTimer.timeString(duration)),
                          onPressed: () {
                            _showTimer(context, exercise.title, duration);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Description extends StatelessWidget {
  final Progression progression;
  final Map<Progression, String> progressions;

  const Description(this.progression, this.progressions);

  String _title() {
    switch (progression) {
      case Progression.ADVANCED:
        return "advanced";
      case Progression.BEGINNER:
        return "beginner";
      case Progression.INTERMEDIATE:
        return "intermediate";
      default:
        throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _title().toUpperCase(),
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.blueGrey),
          ),
          Text(this.progressions[progression]),
        ],
      ),
    );
  }
}
