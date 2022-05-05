import 'package:flutter/material.dart';

class MyDigikala extends StatefulWidget {
  const MyDigikala({Key? key}) : super(key: key);

  @override
  State<MyDigikala> createState() => _MyDigikalaState();
}

class _MyDigikalaState extends State<MyDigikala> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text(
            'دیجی کالای من'
        ),
      ),
    );
  }
}
