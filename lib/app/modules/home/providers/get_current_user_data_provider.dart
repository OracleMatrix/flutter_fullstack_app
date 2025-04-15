import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/modules/Authenticate/Models/user_get_data_model.dart';
import 'package:get/get.dart';

class GetCurrentUserDataProvider extends GetConnect {
  Future<UserGetDataModel?> getCurrentUserData(int id) async {
    try {
      final response = await get(
        '${Constants.baseUrl}/api/users/$id',
        headers: {'authorization': '${await Constants.storage.read("token")}'},
      );

      if (response.body != null) {
        if (response.status.isOk) {
          return userGetDataModelFromJson(response.bodyString!);
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
