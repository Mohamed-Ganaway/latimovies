import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latimovies/main.dart';
import 'package:latimovies/providers/authentication_provider.dart';
import 'package:latimovies/widgets/cards/main_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "LoginScreen",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Email Cannot Be Empty.';
                    }
                    if (!v.contains("@") || !v.contains(".")) {
                      return 'Invalid Email Format.';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Password Cannot Be Empty.';
                    }
                    if (v.length < 8) {
                      return 'Password Must Be At Least 8 Characters Long.';
                    }
                    return null;
                  },
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              MainButton(
                label: "Login",
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .login(emailController.text, passwordController.text)
                        .then((logedIn) {
                      if (logedIn) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const ScreenRouter()),
                            (route) => false);
                      } else {
                        print("FORM IS NOT VALID");
                      }
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
