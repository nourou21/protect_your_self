import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:login_flutter/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basic channel',
            channelName: 'basic notif',
            channelDescription: 'test')
      ],
      debug: true);
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await _initFirebase(); // Initialize Firebase
  await _initHive();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedUsername = prefs.getString('username');
  String? savedPassword = prefs.getString('password');

  if (savedUsername != null && savedPassword != null) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: savedUsername,
        password: savedPassword,
      );

      runApp(
          const MainApp()); // Navigate to the next screen if sign-in is successful
      return;
    } catch (e) {
      print("Automatic sign-in failed: $e");
    }
  }

  runApp(const MainApp()); // Show login page if automatic sign-in failed
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyDBFrj_ITnu_JMrH0N5o3tlS4zPIgzHL-Q',
        appId: '1:918178646392:android:e05d66ea8803c6616a608d',
        messagingSenderId: '918178646392',
        projectId: 'zouaouipfc'),
  ); // Initialize Firebasease
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  await Hive.openBox("login");
  await Hive.openBox("accounts");
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromRGBO(32, 63, 129, 1.0),
          primaryContainer: Colors.pink.shade300,
        ),
      ),
      home: const Login(),
    );
  }
}
