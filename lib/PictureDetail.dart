// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:biyanzhi/Constants.dart';
import 'package:biyanzhi/Util.dart';
import 'package:biyanzhi/model/Comment.dart';
import 'package:biyanzhi/model/Picture.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PictureDetail extends StatefulWidget {
  static const String routeName = '/contacts';
  Picture picture;

  PictureDetail(this.picture);

  @override
  PictureDetailState createState() {
    return new PictureDetailState(picture);
  }
}

class PictureDetailState extends State<PictureDetail> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  Picture picture;
  var commentsIitems = [];

  PictureDetailState(var pict) {
    this.picture = pict;
  }

  @override
  void initState() {
    super.initState();
    _requestComments();
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> commentsLists = commentsIitems.map((var item) {
      return _getCommentItemView(item);
    });
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
        key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              floating: false,
//              snap: true,
              actions: <Widget>[
                new PopupMenuButton<Object>(
                  onSelected: (Object value) {
                    setState(() {
                      /*赋值*/
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<Object>>[
                        const PopupMenuItem<Object>(
                            value: 1, child: const Text('评分详情')),
                        const PopupMenuItem<Object>(
                            value: 2, child: const Text('和TA聊聊')),
                      ],
                ),
              ],
              flexibleSpace: new FlexibleSpaceBar(
                title: new Text(picture.publisher_name),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.network(
                      picture.picture_image_url,
                      fit: BoxFit.cover,
                    ),
                    // This gradient ensures that the toolbar icons are distinct
                    // against the background image.
                    const DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: const Alignment(0.0, -1.0),
                          end: const Alignment(0.0, -0.4),
                          colors: const <Color>[
                            const Color(0x60000000),
                            const Color(0x00000000)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
                      decoration: new BoxDecoration(
                        border: new Border(
                            top: new BorderSide(color: Colors.black12)),
                      ),
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                            padding: new EdgeInsets.only(left: 5.0, right: 5.0),
                            child: new CircleAvatar(
                              radius: 20.0,
                              backgroundImage: new NetworkImage(
                                picture.publisher_avatar,
                              ),
                            ),
                          ),
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                picture.publisher_name,
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              new Text(
                                picture.publish_time,
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      decoration: new BoxDecoration(
                        border: new Border(
                            top: new BorderSide(color: Colors.black12),
                            bottom: new BorderSide(color: Colors.black12)),
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new IconButton(
                              padding:
                                  new EdgeInsets.only(left: 8.0, right: 8.0),
                              iconSize: 50.0,
                              icon: new Icon(
                                Icons.star,
                                color: picture.picColors[0],
                              ),
                              onPressed: () {
                                changeScores(20);
                              }),
                          new IconButton(
                              padding:
                                  new EdgeInsets.only(left: 8.0, right: 8.0),
                              iconSize: 50.0,
                              icon: new Icon(
                                Icons.star,
                                color: picture.picColors[1],
                              ),
                              onPressed: () {
                                changeScores(40);
                              }),
                          new IconButton(
                              padding:
                                  new EdgeInsets.only(left: 8.0, right: 8.0),
                              iconSize: 50.0,
                              icon: new Icon(
                                Icons.star,
                                color: picture.picColors[2],
                              ),
                              onPressed: () {
                                changeScores(60);
                              }),
                          new IconButton(
                              padding:
                                  new EdgeInsets.only(left: 8.0, right: 8.0),
                              iconSize: 50.0,
                              icon: new Icon(
                                Icons.star,
                                color: picture.picColors[3],
                              ),
                              onPressed: () {
                                changeScores(80);
                              }),
                          new IconButton(
                              padding:
                                  new EdgeInsets.only(left: 8.0, right: 8.0),
                              iconSize: 50.0,
                              icon: new Icon(
                                Icons.star,
                                color: picture.picColors[4],
                              ),
                              onPressed: () {
                                changeScores(100);
                              }),
                        ],
                      ),
                    ),
                    new Container(
                      padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(color: Colors.black12)),
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "平均颜值 " + picture.average_score.toString() + " 分",
                            style: new TextStyle(fontSize: 17.0),
                          ),
                        ],
                      ),
                    ),
                    new ListView(
                      children: commentsLists.toList(),
                    )
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCommentItemView(var com) {
    Comment comment = Comment.parseComment(com);
    return new Text(comment.comment_content);
//    return new Container(
//      padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
//      decoration: new BoxDecoration(
//        border: new Border(top: new BorderSide(color: Colors.black12)),
//      ),
//      child: new Row(
//        children: <Widget>[
//          new Padding(
//            padding: new EdgeInsets.only(left: 5.0, right: 5.0),
//            child: new CircleAvatar(
//              radius: 20.0,
//              backgroundImage: new NetworkImage(
//                comment.publisher_avatar,
//              ),
//            ),
//          ),
//          new Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              new Text(
//                comment.publisher_name,
//                style: new TextStyle(
//                  fontSize: 16.0,
//                  color: Colors.black,
//                ),
//              ),
//              new Text(
//                comment.comment_content,
//                style: new TextStyle(fontSize: 14.0, color: Colors.black),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
  }

  changeScores(int score) {
    picture.average_score = score;
    setState(() {
      picture.picColors = Util.changeScores(picture);
    });
  }

  _requestComments() async {
    String url = Util.getPictureCommentsAPI(picture.picture_id.toString());
    var response = await http.read(url);
    Map data = JSON.decode(response);
    var commentsLists = data['comments'];
    print(response);
    setState(() {
      commentsIitems.addAll(commentsLists);
    });
  }
}
