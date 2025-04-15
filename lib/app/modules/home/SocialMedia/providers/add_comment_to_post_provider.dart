import 'package:fullstack_app/app/data/constants.dart';
import 'package:get/get.dart';

class AddCommentToPostProvider extends GetConnect {
  Future addComment({
    required int userId,
    required int postId,
    required String content,
  }) async {
    try {
      final response = await post(
        '${Constants.baseUrl}/api/comments/',
        {'postId': postId, 'userId': userId, 'content': content},
        headers: {'authorization': '${await Constants.storage.read("token")}'},
      );

      if (response.body != null) {
        if (response.status.isOk) {
          return response.bodyString!;
        } else if (response.status.isServerError) {
          throw "Server Error";
        } else if (response.status.isNotFound) {
          throw "Not Found";
        } else {
          throw response.bodyString!;
        }
      } else {
        throw "No data available from server";
      }
    } catch (e) {
      rethrow;
    }
  }
}
