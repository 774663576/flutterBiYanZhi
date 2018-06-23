import 'package:biyanzhi/model/User.dart';

class Comment {
  int comment_id;
  int picture_id;
  int publisher_id;
  String comment_content = "";
  String comment_time = "";
  String publisher_name = "";
  String publisher_avatar = "";
  String reply_someone_name = "";
  int reply_someone_id = 0;
  User user;

  static Comment parseComment(var com) {
    Comment comment = new Comment();
    comment.comment_id = com['publish_time'];
    comment.picture_id = com['picture_id'];
    comment.publisher_name = com['publisher_name'];
    comment.publisher_avatar = com['publisher_avatar'];
    comment.comment_time = com['comment_time'];
    comment.reply_someone_name = com['reply_someone_name'];
    comment.reply_someone_id = com['reply_someone_id'];
    return comment;
  }
}
