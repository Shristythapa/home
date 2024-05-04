import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class LightControlPage extends StatefulWidget {
  const LightControlPage({super.key});

  @override
  State<LightControlPage> createState() => _LightControlPageState();
}

class _LightControlPageState extends State<LightControlPage> {
  bool lightOn = false;
  String light = 'OFF';

  void sendlightStatusToFirebase(String status) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('lightControl')
        .child('lightStatus');
    databaseReference.set(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'light Control',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                lightControlCard(
                  lightName: "light",
                  lightStatus: lightOn,
                  onTap: () {
                    setState(() {
                      lightOn = !lightOn;
                    });

                    light = lightOn ? 'ON' : 'OFF';
                    sendlightStatusToFirebase(light);
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

class lightControlCard extends StatelessWidget {
  final String lightName;
  final bool lightStatus;
  final VoidCallback onTap;

  const lightControlCard({
    super.key,
    required this.lightName,
    required this.lightStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 200.0,
      child: Card(
        color: Colors.teal,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8.0),
              Text(
                lightName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: lightStatus ? Colors.yellow : Colors.white,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                lightStatus ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 15,
                  color: lightStatus ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
