import 'package:flutter/material.dart';

import 'timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lift',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lift'),
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
    StretchCard("Underarm Shoulder Stretch", "potato"),
    StretchCard(
      "Rear Hand Clasp",
      "potato",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StretchCard(
              "Shoulder Extension",
              "Beginner: As above, with palms facing down.\n\nIntermediate: Place your elbows on the object and bring the hands together as it you were praying.\n\nAdvanced: Rotate the palms facing upward. Holding a stick might be useful to help keep the hands from rotating.\n\nAlternatively, a dead hang from a bar in a chinup grip might be used.",
            ),
            StretchCard("Underarm Shoulder Stretch", "potato"),
            StretchCard(
              "Rear Hand Clasp",
              "potato",
            )
          ],
        ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.arrow_forward),
            title: Text(title),
          ),
          Text(mainText),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('1:00'),
                  onPressed: () {
                    _showTimer(context, title, Duration(minutes: 1));
                  },
                ),
                FlatButton(
                  child: Text('1:15'),
                  onPressed: () {
                    _showTimer(
                        context, title, Duration(minutes: 1, seconds: 15));
                  },
                ),
                FlatButton(
                  child: Text('1:30'),
                  onPressed: () {
                    _showTimer(
                        context, title, Duration(minutes: 1, seconds: 30));
                  },
                ),
                FlatButton(
                  child: Text('2:00'),
                  onPressed: () {
                    _showTimer(context, title, Duration(minutes: 2));
                  },
                ),
                FlatButton(
                  child: Text('3:00'),
                  onPressed: () {
                    _showTimer(context, title, Duration(minutes: 3));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
