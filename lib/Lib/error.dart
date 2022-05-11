import 'package:flutter/material.dart';

class Error extends StatefulWidget {
  const Error({Key? key}) : super(key: key);

  @override
  State<Error> createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Image.asset('assets/images/connection.png'),
            Text('خطا در برقراری ارتباط'),
          ],
        ),
      ),
    );
  }
}
