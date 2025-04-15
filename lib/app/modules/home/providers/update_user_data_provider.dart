import 'package:fullstack_app/app/data/constants.dart';
import 'package:get/get.dart';

class UpdateUserDataProvider extends GetConnect {
  Future updateUserData(int id, Map<String, dynamic> data) async {
    try {
      final response = await put(
        '${Constants.baseUrl}/api/users/$id',
        data,
        headers: {'authorization': '${await Constants.storage.read("token")}'},
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
