import 'package:biyanzhi/Util.dart';
import 'package:biyanzhi/model/User.dart';

class Picture {
  var picture_id;

  int publisher_id = 0;
  String publish_time = "";
  String content = "";
  String publisher_name = "";
  String publisher_avatar = "";
  String picture_image_url = "";
  int average_score;
  int state;
  int picture_width;
  int picture_height;
  int score_number;
  User user;
  var picColors;

  static Picture parsePicture(var pic) {
    Picture picture = new Picture();
    picture.picture_id = pic['picture_id'];
    picture.publish_time = pic['publish_time'];
    picture.content = pic['content'];
    picture.publisher_name = pic['publisher_name'];
    picture.publisher_avatar = pic['publisher_avatar'];
    picture.picture_image_url = pic['picture_image_url'];
    picture.average_score = pic['average_score'];
    picture.picColors = Util.changeScores(picture);
    return picture;
  }
}
