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

enum Progression {
  BEGINNER,
  INTERMEDIATE,
  ADVANCED,
}

const EXERCISES = [
  {
    "title": "Shoulder Extension",
    "progressions": {
      Progression.BEGINNER: "As above, with palms facing down.",
      Progression.INTERMEDIATE:
          "Place your elbows on the object and bring the hands together as it you were praying",
      Progression.ADVANCED:
          "Rotate the palms facing upward. Holding a stick might be useful to help keep the hands from rotating. Alternatively, a dead hang from a bar in a chinup grip might be used.",
    },
  },
  {
    "title": "Underarm Shoulder Stretch",
    "progressions": {
      Progression.BEGINNER:
          "As above, keeping hands on the ground, approximately shoulder width.",
      Progression.INTERMEDIATE:
          "Use a stick or resistance band to keep arms narrower than shoulder width.",
      Progression.ADVANCED:
          " Do this while hanging from a bar. Also known as a German Hang",
    },
  },
  {
    "title": "Rear Hand Clasp",
    "progressions": {
      Progression.BEGINNER: "Use a towel or strap to bring the hands together",
      Progression.INTERMEDIATE: "Grab opposing fingers or hands",
      Progression.ADVANCED: "Grab opposing wrists",
    },
  },
  {
    "title": "Full Squat",
    "progressions": {
      Progression.BEGINNER: "Just get into the position and hold",
      Progression.INTERMEDIATE:
          "Work on sitting up as straight as possible. Chest and head held high",
      Progression.ADVANCED:
          "Sit up vertically and attempt to keep the toes pointed forward",
    },
  },
  {
    "title": "Standing Pike",
    "progressions": {
      Progression.BEGINNER: "Forward bend with a flat back",
      Progression.INTERMEDIATE:
          "When below parallel with a flat back grab your calves and pull your knees to your chest",
      Progression.ADVANCED:
          "Pull your knees to your chest without using your arms to pull",
    },
  },
  {
    "title": "Kneeling Lunge",
    "progressions": {
      Progression.BEGINNER:
          "Perform the kneeling lunge with hands on the front leg, supporting some of the torso",
      Progression.INTERMEDIATE:
          "Keep the hands at the side of the torso, with palms facing forward and shoulders pulled back",
      Progression.ADVANCED:
          "Raise the rear leg up against your glutes and hold with both arms",
    },
  },
  {
    "title": "Butterfly",
    "progressions": {
      Progression.BEGINNER:
          "Use strength alone to push the knees towards the floor.",
      Progression.INTERMEDIATE:
          "Lean forward slightly (with a flat back) and press the legs towards the floor by using your elbows.",
      Progression.ADVANCED:
          "Lean forward with a flat back, attempting to touch both your chest to your legs and your knees to the ground.",
    },
  },
  {
    "title": "Backbend",
    "progressions": {
      Progression.BEGINNER:
          "Glute Bridge. While lying on your back, bend your knees and put your feet near your buttocks. By squeezing the glutes, lift the hips and pelvis off the floor and press it towards the ceiling.",
      Progression.INTERMEDIATE:
          "Kneel on your shins on the ground. Curl the toes under your feet, and reach behind you, grabbing the heels with the respective hand. From here, squeeze the glutes and push the pelvis forward as much as possible while holding onto the heels. Look upward and pull the shoulders back. You may need to use blocks or pillows to raise the heels higher at first",
      Progression.ADVANCED:
          "Lie on your back with your knees bent and pulled into your glutes. Place your hands on the ground beside your head, with fingers pointing down towards your shoulders. From here, press with the arms and glutes to lift yourself onto the top of your head. Hold this position for time. As you get better in this position, you will eventually be able to lift your head off the ground by pressing the arms straight. In doing this, make sure your shoulders remain above the hands and much as possible, and strive to straighten the legs.",
    },
  },
  {
    "title": "Lying Twist",
    "progressions": {
      Progression.BEGINNER:
          "Bend the knees at 90 degrees and press down with the arm to deepen the stretch",
      Progression.INTERMEDIATE:
          "Use a straight leg (locked knee) and press down with the arm",
      Progression.ADVANCED:
          "Use a straight leg and no arm assistance - use only muscular power to maintain the position",
    },
  },
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
