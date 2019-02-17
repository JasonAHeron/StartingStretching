enum Progression {
  BEGINNER,
  INTERMEDIATE,
  ADVANCED,
}

class Exercise {
  final String title;
  final Map<Progression, String> progressions;

  const Exercise({this.title, this.progressions});
}

const EXERCISES = [
  Exercise(title: "Shoulder Extension", progressions: {
    Progression.BEGINNER: "As above, with palms facing down.",
    Progression.INTERMEDIATE:
        "Place your elbows on the object and bring the hands together as it you were praying",
    Progression.ADVANCED:
        "Rotate the palms facing upward. Holding a stick might be useful to help keep the hands from rotating. Alternatively, a dead hang from a bar in a chinup grip might be used.",
  }),
  Exercise(title: "Underarm Shoulder Stretch", progressions: {
    Progression.BEGINNER:
        "As above, keeping hands on the ground, approximately shoulder width.",
    Progression.INTERMEDIATE:
        "Use a stick or resistance band to keep arms narrower than shoulder width.",
    Progression.ADVANCED:
        "Do this while hanging from a bar. Also known as a German Hang",
  }),
  Exercise(title: "Rear Hand Clasp", progressions: {
    Progression.BEGINNER: "Use a towel or strap to bring the hands together",
    Progression.INTERMEDIATE: "Grab opposing fingers or hands",
    Progression.ADVANCED: "Grab opposing wrists",
  }),
  Exercise(title: "Full Squat", progressions: {
    Progression.BEGINNER: "Just get into the position and hold",
    Progression.INTERMEDIATE:
        "Work on sitting up as straight as possible. Chest and head held high",
    Progression.ADVANCED:
        "Sit up vertically and attempt to keep the toes pointed forward",
  }),
  Exercise(title: "Standing Pike", progressions: {
    Progression.BEGINNER: "Forward bend with a flat back",
    Progression.INTERMEDIATE:
        "When below parallel with a flat back grab your calves and pull your knees to your chest",
    Progression.ADVANCED:
        "Pull your knees to your chest without using your arms to pull",
  }),
  Exercise(title: "Kneeling Lunge", progressions: {
    Progression.BEGINNER:
        "Perform the kneeling lunge with hands on the front leg, supporting some of the torso",
    Progression.INTERMEDIATE:
        "Keep the hands at the side of the torso, with palms facing forward and shoulders pulled back",
    Progression.ADVANCED:
        "Raise the rear leg up against your glutes and hold with both arms",
  }),
  Exercise(title: "Butterfly", progressions: {
    Progression.BEGINNER:
        "Use strength alone to push the knees towards the floor.",
    Progression.INTERMEDIATE:
        "Lean forward slightly (with a flat back) and press the legs towards the floor by using your elbows.",
    Progression.ADVANCED:
        "Lean forward with a flat back, attempting to touch both your chest to your legs and your knees to the ground.",
  }),
  Exercise(title: "Backbend", progressions: {
    Progression.BEGINNER:
        "Glute Bridge. While lying on your back, bend your knees and put your feet near your buttocks. By squeezing the glutes, lift the hips and pelvis off the floor and press it towards the ceiling.",
    Progression.INTERMEDIATE:
        "Kneel on your shins on the ground. Curl the toes under your feet, and reach behind you, grabbing the heels with the respective hand. From here, squeeze the glutes and push the pelvis forward as much as possible while holding onto the heels. Look upward and pull the shoulders back. You may need to use blocks or pillows to raise the heels higher at first",
    Progression.ADVANCED:
        "Lie on your back with your knees bent and pulled into your glutes. Place your hands on the ground beside your head, with fingers pointing down towards your shoulders. From here, press with the arms and glutes to lift yourself onto the top of your head. Hold this position for time. As you get better in this position, you will eventually be able to lift your head off the ground by pressing the arms straight. In doing this, make sure your shoulders remain above the hands and much as possible, and strive to straighten the legs.",
  }),
  Exercise(title: "Lying Twist", progressions: {
    Progression.BEGINNER:
        "Bend the knees at 90 degrees and press down with the arm to deepen the stretch",
    Progression.INTERMEDIATE:
        "Use a straight leg (locked knee) and press down with the arm",
    Progression.ADVANCED:
        "Use a straight leg and no arm assistance - use only muscular power to maintain the position",
  }),
];
