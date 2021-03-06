import 'package:biyanzhi/Constants.dart';
import 'package:biyanzhi/model/Picture.dart';
import 'package:flutter/material.dart';

class Util {
  static changeScores(Picture picture) {
    var picColors = [];
    if (picture.average_score == 0) {
      picColors = [
        Colors.black38,
        Colors.black38,
        Colors.black38,
        Colors.black38,
        Colors.black38,
      ];
    } else if (picture.average_score <= 20) {
      picColors = [
        Colors.redAccent,
        Colors.black38,
        Colors.black38,
        Colors.black38,
        Colors.black38,
      ];
    } else if (picture.average_score <= 40) {
      picColors = [
        Colors.redAccent,
        Colors.redAccent,
        Colors.black38,
        Colors.black38,
        Colors.black38,
      ];
    } else if (picture.average_score <= 60) {
      picColors = [
        Colors.redAccent,
        Colors.redAccent,
        Colors.redAccent,
        Colors.black38,
        Colors.black38,
      ];
    } else if (picture.average_score <= 80) {
      picColors = [
        Colors.redAccent,
        Colors.redAccent,
        Colors.redAccent,
        Colors.redAccent,
        Colors.black38,
      ];
    } else if (picture.average_score <= 100) {
      picColors = [
        Colors.redAccent,
        Colors.redAccent,
        Colors.redAccent,
        Colors.redAccent,
        Colors.redAccent,
      ];
    }
    return picColors;
  }

  static getPictureCommentsAPI(var picture_id) {
    return Constants.API_HOST +
        "getCommentByPictureID.do?picture_id=" +
        picture_id +
        "&page=1" +
        Constants.COMMON_PARAMETER;
  }

  static getAddCommentAPI(var picture_id, var commentConent) {
    return Constants.API_HOST +
        "addcomment.do?picture_id=" +
        picture_id +
        "&comment_content=" +
        commentConent +
        "&reply_someone_name=&reply_someone_id=0&publisher_name=五月&publisher_avatar=&picture_publisher_id=" +
        Constants.USER_ID +
        Constants.COMMON_PARAMETER;
  }
}
