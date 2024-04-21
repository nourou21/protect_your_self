import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:login_flutter/main.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isFanOn = false;
  bool _areWindowsOpen = false;
  Color _fanButtonColor = Colors.red;
  Color _windowButtonColor = Colors.red;
  Color _backgroundColor = Colors.blueGrey.withOpacity(0.2);

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
    _fetchInitialData();
    _setupFirebaseMessaging();
    _listenToFanState();
    _listenToWindowState();
    _updateBackgroundColor();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.dispose();
  }

  void _fetchInitialData() async {
    // Fetch initial data from the database
    // ...
  }

  void _setupFirebaseMessaging() {
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from notification: ${message.notification?.title}');
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('Opened app from notification: ${message.notification?.title}');
      }
    });
  }

  void _listenToFanState() {
    _database.child('state/fan').onValue.listen((event) {
      var fanState = event.snapshot.value;
      setState(() {
        _isFanOn = fanState == 'on';
        _fanButtonColor = _isFanOn ? Colors.green : Colors.red;
      });
    });
  }

  void _listenToWindowState() {
    _database.child('state/Servo').onValue.listen((event) {
      var windowState = event.snapshot.value;
      setState(() {
        _areWindowsOpen = windowState == 'open';
        _windowButtonColor = _areWindowsOpen ? Colors.green : Colors.red;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      body: Container(
        color: _backgroundColor,
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: StreamBuilder(
                stream: _database.child('state/lcd').onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    return Text(
                      ' ${snapshot.data!.snapshot.value}',
                      style: TextStyle(fontSize: 20),
                    );
                  } else {
                    return Text(
                      'Loading...',
                      style: TextStyle(fontSize: 20),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 400),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _toggleFanState(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            backgroundColor: _fanButtonColor,
                          ),
                          child: Text(
                            _isFanOn ? 'Fan is On' : 'Fan is Off',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _toggleWindowState(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 38),
                            backgroundColor: _windowButtonColor,
                          ),
                          child: Text(
                            _areWindowsOpen ? 'Windows Open' : 'Windows Closed',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFanState() async {
    try {
      var newFanState = _isFanOn ? 'off' : 'on';
      await _database.child('state/fan').set(newFanState);
      print('Fan state updated to: $newFanState');
    } catch (e) {
      print('Error updating fan state: $e');
    }
  }

  Future<void> _toggleWindowState() async {
    try {
      var newWindowState = _areWindowsOpen ? 'close' : 'open';
      await _database.child('state/Servo').set(newWindowState);
      print('Windows state updated to: $newWindowState');
    } catch (e) {
      print('Error updating window state: $e');
    }
  }

  void _updateBackgroundColor() {
    _database.child('state/lcd').onValue.listen((event) {
      if (event.snapshot.value != null) {
        var lcdValue = int.tryParse(event.snapshot.value.toString());
        if (lcdValue != null && lcdValue >= 200) {
          setState(() {
            _backgroundColor = Colors.red.withOpacity(0.5);
            _showGasWarningDialog();
          });
        } else {
          setState(() {
            _backgroundColor = Colors.blueGrey.withOpacity(0.2);
          });
        }
      }
    });
  }

  void _showGasWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gas Detection Warning'),
          content: Text('Gas level is above 200. Please take precautions.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic channel',
        title: 'Gas Detection Warning',
        body: 'Gas level is above 200. Please take precautions.',
        color: Colors.red, // Make the notification red
      ),
    );
  }
}
