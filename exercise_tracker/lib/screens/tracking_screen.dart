import 'dart:async';
import 'dart:developer' as dev;

import 'package:exercise_tracker/screens/running_screen.dart';
import 'package:exercise_tracker/screens/walking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  TrackingPageState createState() => TrackingPageState();
}

//Set up the activity recognition and render tracking screen
class TrackingPageState extends State<TrackingPage> {
  final activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? activityStreamSubscription;
  String activity = '';

  //-------All of the nexessary code to set up the exercise detection---------//

  void onActivityReceive(Activity act) {
    dev.log('Activity Detected >> ${act.toJson()}');
    activityStreamController.sink.add(act);
    activity = act.type.toString();
  }

  void handleError(dynamic error) {
    dev.log('Catch Error >> $error');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activityRecognition = FlutterActivityRecognition.instance;

      //Check for permission
      PermissionRequestResult requestResult;
      requestResult = await activityRecognition.checkPermission();
      if (requestResult == PermissionRequestResult.PERMANENTLY_DENIED) {
        dev.log('Permission is permanently denied.');
        return;
      } else if (requestResult == PermissionRequestResult.DENIED) {
        requestResult = await activityRecognition.requestPermission();
        if (requestResult != PermissionRequestResult.GRANTED) {
          dev.log('Permission is denied.');
          return;
        }
      }

      activityStreamSubscription = activityRecognition.activityStream
          .handleError(handleError)
          .listen(onActivityReceive);
    });
  }

  @override
  void dispose() {
    activityStreamController.close();
    activityStreamSubscription?.cancel();
    super.dispose();
  }

  //--------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 17, 198, 90),
          title: const Text('Tracking Page'),
        ),
        body: displayExercise());
  }

  //Display the content on the Tracking Page screen
  Widget displayExercise() {
    return StreamBuilder<Activity>(
        stream: activityStreamController.stream,
        builder: (context, snapshot) {
          return Stack(children: [
            getActivity(
                activity), //Get the content to put on screen based on activity detected
          ]);
        });
  }

  //Update screen based on activity detected
  Widget getActivity(String act) {
    if (act == 'ActivityType.STILL') {
      return Stack(
        children: const [
          //Error Text
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'You are not moving. Please move to track exercise',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //Error Icon
          Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Icon(
                  Icons.error,
                  size: 300,
                  color: Colors.red,
                )),
          ),
        ],
      );
    } else if (act == 'ActivityType.WALKING') {
      return Stack(
        children: [
          //Text
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'It appears you are walking, press the button below to track your walk',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //Walking icon
          const Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Icon(
                  Icons.directions_walk,
                  size: 300,
                )),
          ),
          //Track walk button
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
                  backgroundColor: const Color.fromARGB(255, 17, 198, 90),
                ),
                child: const Text(
                  'Track Walk',
                  style: TextStyle(fontSize: 35),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WalkingPage()),
                  );
                },
              ),
            ),
          )
        ],
      );
    } else if (act == 'ActivityType.RUNNING') {
      return Stack(
        children: [
          //Text
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'It appears you are running, press the button below to track your run',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //Running icon
          const Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Icon(
                  Icons.directions_run_rounded,
                  size: 300,
                )),
          ),
          //Track run button
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
                  backgroundColor: const Color.fromARGB(255, 17, 198, 90),
                ),
                child: const Text(
                  'Track Run',
                  style: TextStyle(fontSize: 35),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RunningPage()),
                  );
                },
              ),
            ),
          )
        ],
      );
    } else {
      //If the exdercise detection returns "UNKNOWN", then display loading screen
      return const Center(
        child: Text('Loading'),
      );
    }
  }
}
