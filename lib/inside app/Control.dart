import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Color _backgroundColor = Colors.blueGrey.withOpacity(0.2);
  bool _isGasWarningShown = false;
  bool _isManualMode = false;

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
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
      }
    });
  }

  void _listenToFanState() {
    _database.child('state/fan').onValue.listen((event) {
      setState(() {
      });
    });
  }

  void _listenToWindowState() {
    _database.child('state/Servo').onValue.listen((event) {
      setState(() {
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
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: StreamBuilder(
                stream: _database.child('state/lcd').onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    var lcdValue =
                        int.tryParse(snapshot.data!.snapshot.value.toString());
                    if (lcdValue != null) {
                      if (lcdValue > 200) {
                        return Text(
                          'Danger: $lcdValue',
                          style: const TextStyle(fontSize: 20, color: Colors.red),
                        );
                      } else {
                        return Text(
                          'Value: $lcdValue',
                          style: const TextStyle(fontSize: 20),
                        );
                      }
                    }
                  }
                  return const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 20),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(10.0),
                  selectedColor: Colors.white,
                  fillColor: Colors.green,
                  onPressed: (int index) {
                    setState(() {
                      _isManualMode = index == 0; // 0 for Manual, 1 for Auto
                      _toggleManualMode(_isManualMode);
                    });
                  },
                  isSelected: [_isManualMode, !_isManualMode],
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child:const Text(
                        'Manual',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Text(
                        'Auto',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream:
                                  _database.child('state/fan state').onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.snapshot.value != null) {
                                  bool isFanOn =
                                      snapshot.data!.snapshot.value == 'on';
                                  return GestureDetector(
                                    onTap: () {}, // Disable onTap functionality
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 40),
                                      color:
                                          isFanOn ? Colors.green : Colors.red,
                                      child: Text(
                                        isFanOn ? 'Fan is On' : 'Fan is Off',
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            const SizedBox(width: 20),
                            StreamBuilder(
                              stream:
                                  _database.child('state/servo state').onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.snapshot.value != null) {
                                  bool areWindowsOpen =
                                      snapshot.data!.snapshot.value == 'open';
                                  return GestureDetector(
                                    onTap: () {}, // Disable onTap functionality
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 38),
                                      color: areWindowsOpen
                                          ? Colors.green
                                          : Colors.red,
                                      child: Text(
                                        areWindowsOpen
                                            ? 'Windows Open'
                                            : 'Windows Closed',
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 300),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _toggleFanState(true),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Turn Fan On',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _toggleFanState(false),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Turn Fan Off',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _toggleWindowState(true),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 38),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Open Windows',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _toggleWindowState(false),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 28),
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Close Windows',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFanState(bool newState) async {
    try {
      var newFanState = newState ? 'on' : 'off';
      await _database.child('state/fan').set(newFanState);
    // ignore: empty_catches
    } catch (e) {
    }
  }

  Future<void> _toggleWindowState(bool newState) async {
    try {
      var newWindowState = newState ? 'open' : 'close';
      await _database.child('state/Servo').set(newWindowState);
    // ignore: empty_catches
    } catch (e) {
    }
  }

  Future<void> _toggleManualMode(bool isManual) async {
    try {
      _isManualMode = isManual;
      await _database.child('state/manual').set(isManual);
      setState(() {}); // Refresh the UI to reflect the mode change
    // ignore: empty_catches
    } catch (e) {
    }
  }

  void _updateBackgroundColor() {
    _database.child('state/lcd').onValue.listen((event) {
      if (event.snapshot.value != null) {
        var lcdValue = int.tryParse(event.snapshot.value.toString());
        if (lcdValue != null && lcdValue >= 200 && !_isGasWarningShown) {
          // Show alert only if it hasn't been shown before
          setState(() {
            _backgroundColor = Colors.red.withOpacity(0.5);
            _showGasWarningDialog();
            _isGasWarningShown =
                true; // Set the flag to true to indicate that the notification has been shown
          });
        } else if (lcdValue != null && lcdValue < 200) {
          // Reset the flag when the gas level goes below 200
          _isGasWarningShown = false;
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
          title: const Text('Gas Detection Warning'),
          content: const Text('Gas level is above 200. Please take precautions.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
