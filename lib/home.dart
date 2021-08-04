import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int hr = 0;
  int min = 0;
  bool timerStarted = false;
  String timeToDispllay = "00:00:00";
  bool checkTimer = false;
  int timeForTimer = 0;

  startTimer() {
    setState(() {
      checkTimer = true;
    });
    timeForTimer = (hr * 3600) + (min * 60);
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeForTimer < 1 || checkTimer == false) {
          t.cancel();
          checkTimer = false;
          timeToDispllay = "00:00:00";
        } else {
          timeToDispllay = Duration(seconds: timeForTimer)
              .toString()
              .split('.')
              .first
              .padLeft(8, "0");
          timeForTimer = timeForTimer - 1;
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      checkTimer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [timerWidget()],
      ),
      body: Center(
        child: checkTimer
            ? ElevatedButton(
                onPressed: () {
                  stopTimer();
                },
                child: Text('Stop timer'),
              )
            : Text('Timer is not Playing'),
      ),
    );
  }

  Widget timerWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () async {
          //stopTimer();
          await showTimerDialog(context);
        },
        child: Container(
          width: 110,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.stopwatch,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  color: Colors.green.withOpacity(0.7),
                ),
              ),
              Container(
                width: 70,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: Text(
                    timeToDispllay,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Create Alert Dialog __________
  Future<void> showTimerDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Set timer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                NumberPicker(
                                    minValue: 0,
                                    maxValue: 23,
                                    value: hr,
                                    itemWidth: 60,
                                    onChanged: (val) {
                                      setState(() {
                                        hr = val;
                                      });
                                    }),
                                Text(
                                  'hr',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                NumberPicker(
                                  minValue: 0,
                                  maxValue: 59,
                                  value: min,
                                  itemWidth: 60,
                                  onChanged: (val) {
                                    setState(() {
                                      min = val;
                                    });
                                  },
                                ),
                                Text(
                                  'min',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            startTimer();
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30.0, 5, 30, 5),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              //_______________________________________________________________
            );
          },
        );
      },
    );
  }
}
