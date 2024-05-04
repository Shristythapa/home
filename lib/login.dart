import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_sys/dashboard.dart';
import 'package:home_sys/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool buttonPressed = false;

  String email = '';
  bool showPassword = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: form,
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
                        "Login ",
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
                      focusNode: myFocusNode,
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
                      controller: passwordController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "password is required";
                        } else if (value.length < 4) {
                          return 'password must be higher than four character';
                        } else {
                          return null;
                        }
                      },
                      obscureText: !showPassword,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.red[900]),
                        labelText: "password",
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
                      height: 80,
                    ),
                    SizedBox(
                      width: 150,
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
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text)
                                  .then(
                                (value) {
                                  print(value);
                                },
                              );

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const Dashboard(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Login successful!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              print(e);
                              // Show a Snackbar message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Error"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }),
                        child: const Text(
                          "Login",
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
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.teal),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
