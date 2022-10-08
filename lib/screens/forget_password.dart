// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/screens/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForegtPassword extends StatefulWidget {
  const ForegtPassword({super.key});

  @override
  State<ForegtPassword> createState() => _ForegtPasswordState();
}

class _ForegtPasswordState extends State<ForegtPassword>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final _forgetPasswordFromKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "");
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 60), vsync: this);

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  void forgetPasswordForm() async {
    _forgetPasswordFromKey.currentState!.validate();
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(height: 40),
          Image.asset(
            "images/login_w.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
            color: const Color.fromRGBO(255, 255, 255, 0.4),
            colorBlendMode: BlendMode.modulate,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: ListView(
              children: [
                const SizedBox(height: 50),
                Form(
                  key: _forgetPasswordFromKey,
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "FORGET PASSWORD",
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: "Signatra",
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                              wordSpacing: 5,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please enter a valid email address";
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.2),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : MaterialButton(
                              onPressed: () {
                                forgetPasswordForm();
                              },
                              color: Colors.green,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Reset now",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(height: 40),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Back to --->",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                              const TextSpan(text: "  "),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen())),
                                text: "Login",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
