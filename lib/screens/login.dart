import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  /// Takes the [email] and [password] from the form and attempts to log in
  void login() async {
    setState(() {
      loading = true;
    });
    if (!_formKey.currentState!.validate()) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      var error = const Text("An error occurred while logging in");
      if (e.toString().contains('user-not-found')) {
        error = const Text("User not found");
      } else if (e.toString().contains('wrong-password')) {
        error = const Text("Incorrect password");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: error,
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      loading = false;
    });
  }

  /// Disposes of the [email] and [password] controllers
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  /// Builds the login page
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Contact Us'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password'),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(50),
              child: Center(
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(50.0),
                            child: FlutterLogo(
                              size: 100,
                            ),
                          ),
                          if (loading)
                            const CircularProgressIndicator()
                          else
                            Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!RegExp(
                                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: password,
                                  decoration: const InputDecoration(
                                    hintText: 'Password',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: ElevatedButton(
                                    onPressed: login,
                                    child: const Text('Submit'),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ))),
            )));
  }
}
