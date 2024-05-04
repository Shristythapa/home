import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_sys/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool buttonPressed = false;

  String email = '';
  bool showPassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();

  final form = GlobalKey<FormState>();
  void signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed up: ${userCredential.user!.uid}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed Up successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error signing up: $e');
      // Show snackbar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Signing up"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: form,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Color(0xff474747),
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    controller: emailController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Email is invalid";
                      } else if (!value.contains('@gmail.com')) {
                        return 'Email is invalid';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red[900]),
                      prefixIcon: const Icon(Icons.mail, color: Colors.teal),
                      labelText: "email",
                      labelStyle: const TextStyle(
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.teal),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                    controller: password,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "password is required";
                      } else if (value.length < 6) {
                        return 'password must be higher than six character';
                      } else {
                        return null;
                      }
                    },
                    obscureText: !showPassword,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.red[900]),
                      labelText: "Password",
                      labelStyle: const TextStyle(
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.teal),
                      prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                      suffixIcon: showPassword
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: const Icon(Icons.visibility,
                                  color: Colors.teal))
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: const Icon(Icons.visibility_off,
                                  color: Colors.teal),
                            ),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusColor: const Color.fromARGB(255, 141, 125, 164),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onHover: (value) {
                        setState(() {
                          !buttonPressed;
                          ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.teal[200]);
                        });
                      },
                      onPressed: (() async {
                        buttonPressed = !buttonPressed;
                        // if (true) {
                        if (form.currentState!.validate()) {
                          try {
                            signUp(
                              emailController.text,
                              password.text,
                            );
                          } catch (e) {
                            print("not validated");
                          }
                        }
                      }),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.teal),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
