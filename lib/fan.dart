import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class FanControlPage extends StatefulWidget {
  const FanControlPage({super.key});

  @override
  State<FanControlPage> createState() => _FanControlPageState();
}

class _FanControlPageState extends State<FanControlPage> {
  bool fanOn = false;
  String fan = 'OFF';

  void sendfanStatusToFirebase(String status) {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('FanControl')
        .child('FanStatus');
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
          'Fan Control',
          style: TextStyle(color: Colors.black),
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
                FanControlCard(
                  fanName: "Fan",
                  fanStatus: fanOn,
                  onTap: () {
                    setState(() {
                      fanOn = !fanOn;
                    });

                    fan = fanOn ? 'ON' : 'OFF';
                    sendfanStatusToFirebase(fan);
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

class FanControlCard extends StatelessWidget {
  final String fanName;
  final bool fanStatus;
  final VoidCallback onTap;

  const FanControlCard({
    super.key,
    required this.fanName,
    required this.fanStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 200.0,
      child: Card(
        color: Colors.teal[800],
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
                fanName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: fanStatus ? Colors.yellow : Colors.white,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                fanStatus ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 15,
                  color: fanStatus ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
