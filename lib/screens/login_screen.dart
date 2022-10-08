// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/helpers/global_method.dart';
import 'package:fiverr/screens/forget_password.dart';
import 'package:fiverr/screens/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final FocusNode _passFocusNode = FocusNode();
  final _loginFromKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  bool _obSecure = false;
  // ignore: unused_field
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ForegtPassword(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void submitFormOnlogin() async {
    final isValid = _loginFromKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (e) {
        setState(() {
          _isLoading = false;
          GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var padding2 = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      child: ListView(
        children: [
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.only(left: 80, right: 82),
            child: Image.asset(
              "images/login.png",
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _loginFromKey,
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passFocusNode),
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
                const SizedBox(height: 5),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  focusNode: _passFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_obSecure,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return "Please enter a valid password";
                    } else {
                      return null;
                    }
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obSecure = !_obSecure;
                        });
                      },
                      child: Icon(
                        _obSecure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(_createRoute());
                    },
                    child: const Text(
                      "Forget password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  onPressed: submitFormOnlogin,
                  color: Colors.green,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Do not have an account ?",
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
                              builder: (context) => const SignUp())),
                    text: "SignUp",
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
    );
    return Scaffold(
      body: Stack(
        children: [
          // CachedNetworkImage(
          //   imageUrl: loginImageUrl,
          //   placeholder: (context, url) => Image.asset(
          //     "images/login.jpg",
          //     fit: BoxFit.cover,
          //   ),
          //   errorWidget: (context, url, error) => const Icon(Icons.error),
          //   width: double.infinity,
          //   height: double.infinity,
          //   fit: BoxFit.cover,
          //   alignment: FractionalOffset(_animation.value, 0),
          // ),
          Image.asset(
            "images/login_w.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
            color: const Color.fromRGBO(255, 255, 255, 0.4),
            colorBlendMode: BlendMode.modulate,
          ),
          padding2
        ],
      ),
    );
  }
}
