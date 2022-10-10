import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Screen that shows the workout history
class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 17, 198, 90),
              title: const Text('History'),
            ),
            body: ListView(children: getWorkouts(snapshot)),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 17, 198, 90),
              title: const Text('History'),
            ),
          );
        }
      },
    );
  }

  //Get the workouts and print to screen in a list
  getWorkouts(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data?.docs
        .map((doc) => Card(
                child: ListTile(
              title: Text(doc["type"]),
              subtitle: Text(
                  '${doc["date"]}                                ${doc["calories"]} calories ${doc["time"]} seconds'),
              isThreeLine: true,
              leading: Icon(
                checkExerciseType(doc["type"]),
                size: 50,
              ),
            )))
        .toList();
  }

  //Get the correct exercise icon to be displayed on the ListTile
  checkExerciseType(String type) {
    if (type == 'Walk') {
      return Icons.directions_walk;
    } else {
      return Icons.directions_run_rounded;
    }
  }
}
