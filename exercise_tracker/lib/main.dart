import 'package:exercise_tracker/screens/history_screen.dart';
import 'package:exercise_tracker/screens/tracking_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//Reference: https://pub.dev/packages/flutter_activity_recognition
void main() async {
  //Initialize firebase with the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MaterialApp(
    title: 'Exercise Tracker',
    home: Home(),
  ));
}

//Home Page
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 198, 90),
        title: const Text('Home'),
      ),
      body: Stack(
        children: [
          //Title
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'Welcome to the Exercise Tracker',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //App Description
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'This application uses the inbuilt sensors of the phone to identify the type of physical activity taking place',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 460,
            left: 20,
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
                  'Begin Tracking',
                  style: TextStyle(fontSize: 35),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrackingPage()),
                  ); // Navigate to Tracking Page when tapped.
                },
              ),
            ),
          ),
          //Begin Tracking Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 17, 198, 90),
                ),
                child: const Text(
                  'History',
                  style: TextStyle(fontSize: 35),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const History()),
                  ); // Navigate to Tracking Page when tapped.
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
