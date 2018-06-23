import 'dart:async';

import 'package:flutter/material.dart';
import 'package:biyanzhi/HomeMain.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return new _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    new Timer(new Duration(seconds: 3), () {
//      Navigator.of(context).pop(true);
      Navigator
          .of(this.context)
          .push(new MaterialPageRoute(builder: (BuildContext context) {
        return new HomeMain();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Opacity(
            opacity: 1.0, //透明度
            child: new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage('images/wel_bg.jpg'),
                      fit: BoxFit.cover)),
            ),
          ),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(bottom: 20.0),
                  child: new Image.asset(
                    "images/app_logo.png",
                    width: 90.0,
                    height: 90.0,
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(top: 0.0),
                  child: new Text(
                    "比颜值",
                    style: new TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
