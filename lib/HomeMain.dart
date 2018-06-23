// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:biyanzhi/PictureDetail.dart';
import 'package:biyanzhi/model/Picture.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeMain extends StatefulWidget {
  @override
  HomeMainState createState() {
    return new HomeMainState();
  }
}

class HomeMainState extends State<HomeMain> {
  var userInfo;
  var items = [];
  var xiuChanIitems = [];

  var last_publish_time;
  var first_publish_time = '';
  var xiuchang_last_publish_time;
  var xiuchang_first_publish_time = '';
  var xiuchang_page = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const List<String> _drawerContents = const <String>[
    '私信',
    '去评分',
    '检查更新',
    '关于',
    '退出登录',
  ];

  @override
  void initState() {
    super.initState();
    _requestData();
    _requestXiuChangData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  IconData _menuIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return Icons.menu;
    }
    assert(false);
    return null;
  }

  void _showNotImplementedMessage() {
    Navigator.of(context).pop(); // Dismiss the drawer.
    // toast
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> lists = items.map((var item) {
      return _getView(item);
    });
    Iterable<Widget> xiuChangLists = xiuChanIitems.map((var item) {
      return _getViewForXiuChang(item);
    });
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: new IconButton(
              icon: new Icon(_menuIcon()),
              alignment: Alignment.centerLeft,
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            title: const Text('比颜值'),
            bottom: new TabBar(
              tabs: [
                new Tab(
                  text: '秀颜值',
                ),
                new Tab(
                  text: '秀场',
                )
              ],
              labelStyle: new TextStyle(fontSize: 17.0),
            ),
          ),
          drawer: new Drawer(
            child: new Column(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: const Text('五月'),
                  accountEmail: const Text('北京 海淀'),
                  currentAccountPicture: new CircleAvatar(
                    backgroundImage: new NetworkImage(
                      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528117177923&di=8ea34a799a3924a5d9194c860387564e&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201507%2F30%2F20150730112008_WrYty.jpeg',
                    ),
                  ),
                  margin: EdgeInsets.zero,
                ),
                new MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: new Expanded(
                    child: new ListView(
                      padding: const EdgeInsets.only(top: 8.0),
                      children: <Widget>[
                        new Stack(
                          children: <Widget>[
                            new Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _drawerContents.map((String item) {
                                  return new ListTile(
                                    title: new Text('$item'),
                                    onTap: _showNotImplementedMessage,
                                  );
                                }).toList()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: new TabBarView(
            children: [
              new RefreshIndicator(
                child: new GridView.count(
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  crossAxisCount: 2,
                  children: lists.toList(),
                ),
                onRefresh: () {
                  return _requestData();
                },
              ),
              new RefreshIndicator(
                child: new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: new ListView(
                    children: xiuChangLists.toList(),
                  ),
                ),
                onRefresh: () {
                  return _refushXiuChang();
                },
              ),
            ],
          ),
        ));
  }

  Widget _getView(var picture) {
    return new GestureDetector(
        onTap: () {
          Picture pic = Picture.parsePicture(picture);
          Navigator
              .of(this.context)
              .push(new MaterialPageRoute(builder: (BuildContext context) {
            return new PictureDetail(pic);
          }));
        },
        child: new Container(
          decoration: new BoxDecoration(
              border: new Border.all(width: 1.0, color: Colors.black12),
              borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
          margin: const EdgeInsets.all(4.0),
          child: new Column(
            children: <Widget>[
              new Expanded(
                  child: new Padding(
                padding: new EdgeInsets.all(2.0),
                child: new Image.network(
                  picture['picture_image_url'],
                  fit: BoxFit.fitWidth,
                  width: 500.0,
                ),
              )),
              new Padding(
                padding: new EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: new Text("平均颜值(" +
                    picture['average_score'].toString() +
                    ") " +
                    picture['score_number'].toString() +
                    "人评分"),
              ),
            ],
          ),
        ));
  }

  Widget _getViewForXiuChang(var xiuchang) {
    return new Container(
        decoration: new BoxDecoration(
            border: new Border.all(width: 1.0, color: Colors.black12),
            borderRadius: const BorderRadius.all(const Radius.circular(8.0))),
        margin: const EdgeInsets.all(4.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: new CircleAvatar(
                    backgroundImage: new NetworkImage(
                      xiuchang['user']['user_avatar'],
                    ),
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      xiuchang['user']['user_name'],
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    new Text(xiuchang['time']),
                  ],
                ),
              ],
            ),
            new Divider(
              height: 3.0,
            ),
            new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new Text(xiuchang['content']),
            ),
            _buildXiuChangImage(xiuchang['images']),
            new Divider(
              height: 2.0,
            ),
            new Padding(
              padding: new EdgeInsets.all(7.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Expanded(
                      child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Image.asset(
                        'images/praise_img_nomal.png',
                        width: 19.0,
                        height: 19.0,
                      ),
                      new Text(
                          "赞 (" + xiuchang['praise_count'].toString() + ")"),
                    ],
                  )),
                  new Expanded(
                      child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Image.asset(
                        'images/icon_comment.png',
                        width: 19.0,
                        height: 19.0,
                      ),
                      new Text(
                          "评论 (" + xiuchang['comment_count'].toString() + ")"),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ));
  }

  _buildXiuChangImage(var item) {
    var images = [];
    images = item;
    if (images == null || images.length == 0) {
      return new Text("");
    }
    print("images--len--" + images.length.toString());
    if (images.length == 1) {
      return new Image.network(images[0]['img_url']);
    } else if (images.length == 2) {
      return new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Expanded(
            child: new Image.network(
              images[0]['img_url'],
              fit: BoxFit.cover,
              height: 150.0,
            ),
          ),
          new Divider(
            indent: 3.0,
            color: Colors.white,
          ),
          new Expanded(
            child: new Image.network(
              images[1]['img_url'],
              fit: BoxFit.cover,
              height: 150.0,
            ),
          ),
        ],
      );
    } else if (images.length == 3) {
      return new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: new Image.network(
                  images[0]['img_url'],
                  fit: BoxFit.cover,
                  height: 150.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[1]['img_url'],
                  fit: BoxFit.cover,
                  height: 150.0,
                ),
              ),
            ],
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 3.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  child: new Image.network(
                    images[2]['img_url'],
                    fit: BoxFit.cover,
                    height: 150.0,
                  ),
                ),
                new Expanded(child: new Text("")),
              ],
            ),
          ),
        ],
      );
    } else if (images.length == 4) {
      return new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: new Image.network(
                  images[0]['img_url'],
                  fit: BoxFit.cover,
                  height: 150.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[1]['img_url'],
                  fit: BoxFit.cover,
                  height: 150.0,
                ),
              ),
            ],
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 3.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  child: new Image.network(
                    images[2]['img_url'],
                    fit: BoxFit.cover,
                    height: 150.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[3]['img_url'],
                    fit: BoxFit.cover,
                    height: 150.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (images.length == 5) {
      return new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: new Image.network(
                  images[0]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[1]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[2]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
            ],
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 3.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  child: new Image.network(
                    images[3]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[4]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (images.length == 6) {
      return new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: new Image.network(
                  images[0]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[1]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[2]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
            ],
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 3.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  child: new Image.network(
                    images[3]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[4]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[5]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (images.length == 9) {
      return new Column(
        children: <Widget>[
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Expanded(
                child: new Image.network(
                  images[0]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[1]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
              new Divider(
                color: Colors.white,
                indent: 3.0,
              ),
              new Expanded(
                child: new Image.network(
                  images[2]['img_url'],
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
              ),
            ],
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 3.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  child: new Image.network(
                    images[3]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[4]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[5]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 3.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Expanded(
                  child: new Image.network(
                    images[6]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[7]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 3.0,
                ),
                new Expanded(
                  child: new Image.network(
                    images[8]['img_url'],
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return new Image.network(images[0]['img_url']);
    }
  }

  Widget _getViewForXiuChangImages(var image) {
    return new Image.network(image['img_url']);
  }

  _loadMore() async {
    print("loadmore--");
//    var response;
//    String url =
//        'http://10.155.237.78:8080/biyanzhi/loadMorePictureList.do?publish_time=0&user_id=100&requestFrom=wechat';
//    String url =
//        'http://10.155.237.78:8080/biyanzhi/loadMorePictureList.do?publish_time=' +
//            last_publish_time +
//            '&user_id=100&requestFrom=wechat';
//    response = await http.read(url);
//    print('Response=$response');
//    Map data = JSON.decode(response);
//    var pictures = data['pictures'];
//    setState(() {
//      items = pictures;
//      print("length-" + items.length.toString());
//    });
  }

  _requestData() async {
    var response;
    String url =
        'http://10.155.237.78:8080/biyanzhi/getpicturelists.do?publish_time=' +
            first_publish_time +
            '&user_id=992&requestFrom=wechat';
    response = await http.read(url);
    Map data = JSON.decode(response);
    var pictures = data['pictures'];
    setState(() {
      items.addAll(pictures);
      print("length-" + items.length.toString());
      if (items.length > 1) {
        last_publish_time = items[items.length - 1]['publish_time'];
      }
      if (items.length > 0) {
        first_publish_time = items[0]['publish_time'];
      }
    });
  }

  _requestXiuChangData() async {
    var response;
    String url = 'http://10.155.237.78:8080/biyanzhi/getXiuYiXiuList.do?time=' +
        xiuchang_first_publish_time +
        '&user_id=992&requestFrom=wechat&page=' +
        xiuchang_page.toString();
    response = await http.read(url);
    Map data = JSON.decode(response);
    var xiuchangLists = data['xiuyixiulists'];
    setState(() {
      xiuChanIitems.addAll(xiuchangLists);
      print("length-" + xiuChanIitems.length.toString());
      if (xiuChanIitems.length > 1) {
        xiuchang_last_publish_time =
            xiuChanIitems[xiuChanIitems.length - 1]['publish_time'];
      }
      if (xiuChanIitems.length > 0) {
        xiuchang_first_publish_time = xiuChanIitems[0]['publish_time'];
      }
    });
  }

  _getUserInfo() async {
    var response;
    String url =
        'http://10.155.237.78:8080/biyanzhi/getUserInfo.do?publicsher_user_id=1456&user_id=992&requestFrom=wechat&app_version_code=0';
    response = await http.read(url);
    Map data = JSON.decode(response);
  }

  _refushXiuChang() {
    print("下载刷新");
    setState(() {});
  }
}
