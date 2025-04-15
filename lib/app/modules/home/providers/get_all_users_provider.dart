import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/modules/home/Models/get_all_users_model.dart';
import 'package:get/get.dart';

class GetAllUsersProvider extends GetConnect {
  Future<List<GetAllUsersModel>?> getAllUsers() async {
    try {
      final response = await get(
        '${Constants.baseUrl}/api/users/',
        headers: {'authorization': '${await Constants.storage.read('token')}'},
      );
      if (response.body != null) {
        if (response.status.isOk) {
          return getAllUsersModelFromJson(response.bodyString!);
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
