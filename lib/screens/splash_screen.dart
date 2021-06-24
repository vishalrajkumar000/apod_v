import 'dart:convert';

import 'package:apod_v/screens/apod_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    getPOD();
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        ColorTween(begin: Colors.black, end: Color.fromRGBO(0, 15, 55, 100))
            .animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
    // Timer(Duration(seconds: 3),
    //     () => {Navigator.pushReplacementNamed(context, '/apod')});
  }

  //getPOD -->function to get data from NASA API

  void getPOD() async {
    Uri URL = Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=8HdRGjwqrDNbEiCo25Qkn7ReMhBQGOChlAnu3hG1');
    http.Response response = await http.get(URL);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => APODScreen(
                    data: data,
                    limit: response.headers['x-ratelimit-remaining'],
                  )));
    } else {
      print(response.statusCode);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _animation.value,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('images/APOD-V.png'),
            ),
            Text(
              '©2021',
              style: TextStyle(color: Colors.grey),
            )
          ],
        )));
  }
}
