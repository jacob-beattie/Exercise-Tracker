import 'package:cloud_firestore/cloud_firestore.dart';

//This class is used for the database that is connected to the app.
//I created this class to make the code cleaner and simpler.
class DataBase {
  //Get the workouts collection
  static CollectionReference workouts =
      FirebaseFirestore.instance.collection('workouts');

  //Save a workout to the database. It is Future because it is saving to a database
  Future<void> saveWorkout(int calories, int time, String date, String type) {
    return workouts
        .add({'calories': calories, 'time': time, 'date': date, 'type': type});
  }
}
