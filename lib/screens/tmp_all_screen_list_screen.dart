import 'package:flutter/material.dart';
import 'package:untitled/utils/app_routes.dart';

class TmpAllScreenListScreen extends StatelessWidget {
  TmpAllScreenListScreen({super.key});

  final List routeNames = AppRoutes.routes.keys.toList();

  Widget listItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeNames[index]);
      },
      child: Container(
        height: 45,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.only(left: 8),
        alignment: Alignment.centerLeft,
        decoration: ShapeDecoration(
          color: Color(0xFFCAE4C1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          routeNames[index].substring(1),
          style: TextStyle(
            color: Colors.deepOrangeAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Scrollbar(
          interactive: true,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 8,
          radius: Radius.circular(10),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: AppRoutes.routes.length,
            itemBuilder: (BuildContext context, int index) =>
                listItem(context, index),
          ),
        ),
      ),
    );
  }
}
