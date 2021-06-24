import 'dart:convert' as convert;

import 'package:apod_v/components/pod.dart';
import 'package:apod_v/components/secrets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class APODScreen extends StatefulWidget {
  final data, limit;
  const APODScreen({Key? key, this.data, this.limit}) : super(key: key);
  static const String id = "apod_screen";
  @override
  _APODScreenState createState() => _APODScreenState(data, limit);
}

class _APODScreenState extends State<APODScreen> {
  var data, limit;
  _APODScreenState(this.data, this.limit);
  DateTime today = DateTime.now();
  DateTime currentDate = DateTime.now();

  //_selectDate --> function that brings up date selector and gets the selected date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1996),
        lastDate: today);
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        getPOD();
      });
  }

  //_launchURL --> function to launch url when pressed on buttons

  void _launchURL(int i) async {
    const instaURL = 'https://instagram.com';
    const mailURL = 'mailto:vishalrajkumar13232@gmail.com';
    const apodURL = 'https://glacial-cove-14244.herokuapp.com/pod';
    if (i == 1) {
      if (await canLaunch(mailURL)) {
        Navigator.of(context).pop();
        await launch(mailURL);
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Sorry check your connection and try again!⚡",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.grey[800],
          duration: Duration(seconds: 2),
        ));
      }
    } else if (i == 2) {
      if (await canLaunch(instaURL)) {
        Navigator.of(context).pop();
        await launch(instaURL);
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Sorry check your connection and try again!⚡",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.grey[800],
          duration: Duration(seconds: 2),
        ));
      }
    } else if (i == 3) {
      if (await canLaunch(apodURL)) {
        Navigator.of(context).pop();
        await launch(apodURL);
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Sorry check your connection and try again!⚡",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.grey[800],
          duration: Duration(seconds: 2),
        ));
      }
    }
  }

  //getPOD --> function to get data from NASA API

  void getPOD() async {
    Uri URL = Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=$API_KEY&date=${currentDate.toString().substring(0, 10)}');
    print(URL);
    http.Response response = await http.get(URL);
    if (response.statusCode == 200) {
      data = convert.jsonDecode(response.body);
      print(data);
      setState(() {});
      limit = response.headers['x-ratelimit-remaining'];
    } else if (response.statusCode == 429) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Hourly limit reached",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.grey[300],
            ),
          ),
          content: Text(
            "Sorry!!Your hourly limit has reached😪.Please wait it will be reset soon!",
            style: TextStyle(
              fontSize: 17.5,
              color: Colors.grey[350],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.help_outline_rounded,
                    size: 25.0,
                  ),
                  title: Text(
                    "Help",
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, "Help");
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Help or Queries",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey[300],
                          ),
                        ),
                        content: Text(
                          "For any help,queries or suggestions to improve contact us.",
                          style: TextStyle(
                            fontSize: 17.5,
                            color: Colors.grey[350],
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              _launchURL(1);
                            },
                            icon: Icon(
                              Icons.mail_outline,
                              size: 30.0,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _launchURL(2);
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.instagram,
                              size: 30.0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context, "About");
                    showAboutDialog(
                        context: context,
                        applicationIcon: CircleAvatar(
                            radius: 45.0,
                            backgroundImage: AssetImage('images/app_icon.png')),
                        applicationName: "APOD-V",
                        applicationVersion: "version 1.0",
                        children: [
                          Text(
                            "This app fetches you the NASA Astronomy Picture of the Day(APOD) for particular selected day.Also check out our website.",
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _launchURL(3);
                            },
                            child: Text(
                              "APOD-V",
                            ),
                            style: ButtonStyle(),
                          ),
                        ]);
                  },
                  leading: Icon(
                    Icons.info_outline_rounded,
                    size: 25.0,
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context, "Hourly Limit");
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          "Hourly Limit",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey[300],
                          ),
                        ),
                        content: Text(
                          "Remaining requests: $limit",
                          style: TextStyle(
                            fontSize: 17.5,
                            color: Colors.grey[350],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 17.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.watch_later_outlined,
                    size: 25.0,
                  ),
                  title: Text(
                    "Hourly Limit",
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Color.fromRGBO(0, 15, 65, 100),
        toolbarHeight: 80.0,
        title: Image.asset(
          'images/APOD-V.png',
          height: 60.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(0, 15, 125, 100),
                      onPrimary: Colors.white70,
                    ),
                    onPressed: () {
                      _selectDate(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Select any date from 1996 to today!!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[800],
                          ),
                        ),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    child: Text('Select any Date'),
                  ),
                ),
              ],
            ),
            SafeArea(child: data != null ? POD(data: data) : Container()),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
