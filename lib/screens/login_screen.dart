import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey =
      GlobalKey<FormState>(); //_formkey is used to validate the form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //safe area is used for avoid ui overlap with notch, status bar etc.
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              //used to make screen scrollable when keyboard opens
              child: ConstrainedBox(
                //this ensures full height so centering works
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  //Centers your login card on screen
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 5, //elevation for shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, //prevents column from stretching full height
                          children: [
                            // Logo / Title
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 30),

                            //FORM
                            Form(
                              key: _formKey, //connect form with _formkey
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Email Field
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        //cannot empty
                                        return "Enter email";
                                      }
                                      if (!value.contains('@')) {
                                        //must contain @
                                        return "Enter valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Field
                                  TextFormField(
                                    obscureText: true, //Hides password(***)
                                    decoration: const InputDecoration(
                                      labelText: "Password",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter password";
                                      }
                                      if (value.length < 6) {
                                        return "Min 6 characters required";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),

                                  //Forgot Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Forgot Password clicked",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("Forgot Password?"),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  //Sign In Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Signing in..."),
                                            ),
                                          );

                                          Navigator.pushReplacementNamed(
                                            context,
                                            '/home',
                                          ); //it uses for routing to home screen if you successfully login then it redirect to the login
                                        }
                                      },
                                      child: const Text("Sign In"),
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // Bottom Sign Up
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Don't have an account? Sign up",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
