import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_sys/fan.dart';

import 'package:home_sys/light.dart';
import 'package:home_sys/login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Text(
              "Home",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                // fontFamily: "Times New Roman",
              ),
            ),
            Expanded(
              flex: 2,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Button Intruder Face Recognition action
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LightControlPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(180, 150),
                    ),
                    child: const Text(
                      'Light',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Button Intruder Face Recognition action
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const FanControlPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(180, 150),
                    ),
                    child: const Text(
                      'Fan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(180, 150),
                    ),
                    child: const Text(
                      'Temp: ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // Navigate to the login page or any other page after logout
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } catch (e) {
                      // Handle logout errors
                      print('Error logging out: $e');
                    }
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }
}
