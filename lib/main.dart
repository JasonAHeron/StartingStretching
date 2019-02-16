import 'package:flutter/material.dart';

import 'timer.dart';
import 'package:lift/exercise.dart';

void main() => runApp(MyApp());

const TIMER_PRESETS = [
  {"title": '1:00', "duration": Duration(minutes: 1)},
  {"title": '1:15', "duration": Duration(minutes: 1, seconds: 15)},
  {"title": '1:30', "duration": Duration(minutes: 1, seconds: 30)},
  {"title": '2:00', "duration": Duration(minutes: 2)},
  {"title": '3:00', "duration": Duration(minutes: 3)},
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starting Stretching',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
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
  var remainingStretches;

  @override
  void initState() {
    super.initState();
    remainingStretches = new List<Map<String, Object>>.from(EXERCISES);
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
            key: Key(exercise["title"]),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              // Remove the item from our data source.
              setState(() {
                remainingStretches.removeAt(index);
              });

              // Then show a snackbar!
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("${exercise["title"]} completed!")));
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
            child: StretchCard(exercise["title"], ""),
          );
        },
      ),
    );
  }
}

class StretchCard extends StatelessWidget {
  final String title;
  final String mainText;

  StretchCard(this.title, this.mainText);

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: mainText.isEmpty ? Container() : Text(mainText),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: TIMER_PRESETS
                    .map((timer) => FlatButton(
                          child: Text(timer["title"]),
                          onPressed: () {
                            _showTimer(context, title, timer["duration"]);
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
