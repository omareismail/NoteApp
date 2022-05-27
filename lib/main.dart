import 'package:final_project/home.dart';
import 'package:final_project/data.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String ambe = "amber";
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) {
              return Home();
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/logo.jpg",
              width: 200,
            ),
            Container(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5),
                    backgroundColor: MaterialStateProperty.all(
                        data.c.keys.toList()[data.index])),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (_) {
                    return Home();
                  }));
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              width: 200,
            )
          ],
        ),
      ),
    );
  }
}
