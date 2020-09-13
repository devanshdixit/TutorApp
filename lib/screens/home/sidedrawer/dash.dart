import 'package:tutorApp/models/user.dart';
import 'package:tutorApp/screens/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:tutorApp/loading.dart';

class Dash extends StatefulWidget {
  final UserType data;
  Dash({this.data});
  @override
  _DashState createState() => _DashState(data: data);
}

class _DashState extends State<Dash> {
  final UserType data;
  _DashState({this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Dashboard'),
      ),
      body: DashBoard(
        data: data,
      ),
    );
  }
}
