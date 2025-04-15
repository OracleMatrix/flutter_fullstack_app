import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/modules/home/SocialMedia/Models/get_all_post_comments_model.dart';
import 'package:get/get.dart';

class GetPostsCommentsProvider extends GetConnect {
  Future<List<GetAllPostCommentsModel>?> getAllPosts(int id) async {
    try {
      final response = await get(
        '${Constants.baseUrl}/api/comments/post/$id',
        headers: {'authorization': '${await Constants.storage.read("token")}'},
      );

      if (response.body != null) {
        if (response.status.isOk) {
          return getAllPostCommentsModelFromJson(response.bodyString!);
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
