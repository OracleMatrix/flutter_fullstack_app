import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/modules/Authenticate/Models/user_get_data_model.dart';
import 'package:get/get.dart';

class RegisterProvider extends GetConnect {
  Future<UserGetDataModel?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await post('${Constants.baseUrl}/api/users/register', {
        "name": name,
        "email": email,
        "password": password,
      });

      if (response.headers?['authorization'] != null) {
        await Constants.storage.write(
          'token',
          response.headers!['authorization'],
        );
      }

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
