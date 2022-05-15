import 'dart:async';

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  int show = 1;
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          show == 1 ? active() : inActive(),
          show == 2 ? active() : inActive(),
          show == 3 ? active() : inActive(),
        ],
      ),
    );
  }

  Widget active() {
    return Container(
      width: 10.0,
      height: 10,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }

  Widget inActive() {
    return Container(
      width: 10.0,
      height: 10,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (show == 3) {
        show = 1;
      } else {
        show = show + 1;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
}
