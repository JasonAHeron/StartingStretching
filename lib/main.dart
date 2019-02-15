import 'package:flutter/material.dart';

import 'timer.dart';

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
  final stretchList = [
    StretchCard(
      "Shoulder Extension",
      "Beginner: As above, with palms facing down.\n\nIntermediate: Place your elbows on the object and bring the hands together as it you were praying.\n\nAdvanced: Rotate the palms facing upward. Holding a stick might be useful to help keep the hands from rotating.\n\nAlternatively, a dead hang from a bar in a chinup grip might be used.",
    ),
    StretchCard("Underarm Shoulder Stretch", ""),
    StretchCard("Rear Hand Clasp", ""),
    StretchCard("Full Squat", ""),
    StretchCard("Standing Pike", ""),
    StretchCard("Kneeling Lunge", ""),
    StretchCard("Butterfly", ""),
    StretchCard("Backbend", ""),
    StretchCard("Lying Twist", ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: stretchList.length,
        itemBuilder: (context, index) {
          final item = stretchList[index];
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify Widgets.
            key: Key(item.title),
            // We also need to provide a function that tells our app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from our data source.
              setState(() {
                stretchList.removeAt(index);
              });

              // Then show a snackbar!
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("$item dismissed")));
            },
            // Show a red background as the item is swiped away
            background: Container(color: Colors.red),
            child: item,
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
                            _showTimer(
                                context, timer["title"], timer["duration"]);
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
