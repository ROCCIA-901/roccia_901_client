import 'package:flutter/material.dart';


class MyPageScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyPageScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffcae4c1),
          elevation: 0,
          centerTitle: true,
          title: Text("4 slide"),
        ),
        body: Center(child: Text('4',style: TextStyle(fontSize: 40)))
    );
  }
}