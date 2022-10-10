import 'dart:async';

import 'package:exercise_tracker/components/database.dart';
import 'package:exercise_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:dp_stopwatch/dp_stopwatch.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../components/stopwatch.dart';

class RunningPage extends StatefulWidget {
  const RunningPage({super.key});

  @override
  State<StatefulWidget> createState() => RunningPageState();
}

class RunningPageState extends State<RunningPage> {
  //Stopwatch used on screen
  StopWatch stopWatch = StopWatch();

  //Variables to calculate calories burned
  double met = 10; //MET for running pace
  double weight = 75;
  int calories = 0;

  //Timer for counting the calories
  late Timer newTimer;
  late Timer workoutTimer;

  //The time the exercise took
  int exerciseTime = 0;

  //Database to write to
  DataBase data = DataBase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 198, 90),
        title: const Text('Run'),
      ),
      body: Stack(
        children: [
          //Running icon
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Icon(
                  Icons.directions_run_rounded,
                  size: 100,
                )),
          ),
          //Stopwatch
          Positioned(
            top: 150,
            left: 90,
            child: DPStopWatchWidget(stopWatch.get()),
          ),
          //Calories Burned title
          const Positioned(
              top: 350,
              left: 45,
              child: Text(
                'Calories Burned:',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
          //Calorie Count
          Positioned(
            top: 420,
            left: 140,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5),
                  borderRadius: const BorderRadius.all(Radius.circular(200))),
              padding: const EdgeInsets.all(10),
              child: Text(
                calories.toString(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          //Finish Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                ),
                child: const Text(
                  'Finish',
                  style: TextStyle(fontSize: 35),
                ),
                onPressed: () {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
                  data.saveWorkout(calories, exerciseTime, formattedDate,
                      'Run'); //Save the workout to the database
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                    (Route<dynamic> route) => false,
                  ); //Navigate back to the home page when finished exercise
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //Timer to increment the calorie count every 30 seconds
    newTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        calories = (calories + (met * 3.5 * weight / 200) / 6).round();
      });
    });

    //Timer to increment the exercise time count every second
    workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        exerciseTime += 1;
      });
    });

    //Begin the timer when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) => stopWatch.start());
  }

  @override
  void dispose() {
    super.dispose();
    //Stop the calorie counting timer
    newTimer.cancel();
    workoutTimer.cancel();
    stopWatch.stop();
  }
}
