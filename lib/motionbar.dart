// In your existing main.dart file

import 'package:flutter/material.dart';
import 'package:login_flutter/inside%20app/Control.dart';
import 'package:login_flutter/inside%20app/apropsdenous.dart';
import 'package:login_flutter/inside%20app/home.dart';

class MotionTabPage extends StatefulWidget {
  @override
  _MotionTabPageState createState() => _MotionTabPageState();
}

class _MotionTabPageState extends State<MotionTabPage>
    with TickerProviderStateMixin {
  late TabController _motionTabController;

  @override
  void initState() {
    super.initState();
    _motionTabController =
        TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _motionTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 4.0,
        child: TabBar(
          controller: _motionTabController,
          tabs: const [
            Tab(icon: Icon(Icons.feed), text: 'CONTRÔLE'),
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(
                icon: Icon(Icons.account_circle_rounded),
                text: 'À propos de nous'),
          ],
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.blue,
          indicator: const BoxDecoration(),
        ),
      ),
      body: TabBarView(
        controller: _motionTabController,
        children: <Widget>[
          ControlPage(), // Use the ControlPage widget here
          HomePage(), // Use the HomePage widget here
          Apropsdenous(),
        ],
      ),
    );
  }
}

class motion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Protect Yourself',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MotionTabPage(),
    );
  }
}
