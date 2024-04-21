import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_flutter/login/login.dart';
import 'package:login_flutter/main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isBold = true;

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainApp()),
        (route) => false,
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // Hide the system UI (task bar) when the widget is initialized
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    // Show the system UI (task bar) when the widget is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF image
          Positioned.fill(
            child: Image.asset(
              'assets/gaz.gif', // Provide the path to your GIF image
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          // Content
          Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 82),
                    Center(
                      child: TyperAnimatedTextKit(
                        onTap: () {
                          print("Tap Event");
                        },
                        text: ["Protect yourself"],
                        textStyle: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                        speed: Duration(milliseconds: 100),
                        isRepeatingAnimation: false,
                        totalRepeatCount: 1,
                      ),
                    ),
                    SizedBox(height: 420),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        TyperAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: ["You're in danger"],
                          textStyle: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                          speed: Duration(milliseconds: 100),
                          isRepeatingAnimation: false,
                          totalRepeatCount: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: _isBold
                          ? TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Colors.red,
                            )
                          : TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                              color: Colors.red,
                            ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isBold = !_isBold;
                          });
                        },
                        child: Text(
                          "   💀 mortal 💀",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Sign-out button
                    Row(
                      children: [
                        SizedBox(
                          width: 260,
                        ),
                        TextButton(
                          onPressed: _signOut,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
