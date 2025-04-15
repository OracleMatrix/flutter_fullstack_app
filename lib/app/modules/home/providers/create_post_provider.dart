import 'package:fullstack_app/app/data/constants.dart';
import 'package:get/get.dart';

class CreatePostProvider extends GetConnect {
  Future createPost(String title, String content, int id) async {
    try {
      final response = await post(
        '${Constants.baseUrl}/api/posts/$id',
        {"title": title, "content": content},
        headers: {'authorization': '${await Constants.storage.read('token')}'},
      );

      if (response.body != null) {
        if (response.status.isOk) {
          return response.body;
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
