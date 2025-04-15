import 'package:flutter/material.dart';
import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/modules/Authenticate/Models/user_get_data_model.dart';
import 'package:fullstack_app/app/modules/home/providers/delete_user_provider.dart';
import 'package:fullstack_app/app/modules/home/providers/get_current_user_data_provider.dart';
import 'package:fullstack_app/app/modules/home/providers/update_user_data_provider.dart';
import 'package:fullstack_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  var userData = UserGetDataModel().obs;
  var getCurrentUserProvider = GetCurrentUserDataProvider();
  var deleteUserProvider = DeleteUserProvider();
  var updateUserDataProvider = UpdateUserDataProvider();

  var nameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  Future getCurrentUserData() async {
    try {
      isLoading.value = true;
      final id = await Constants.storage.read('id');
      final data = await getCurrentUserProvider.getCurrentUserData(id);
      if (data != null) {
        userData.value = data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteUser() async {
    try {
      isLoading.value = true;
      final id = await Constants.storage.read('id');
      final data = await deleteUserProvider.deleteUser(id);
      if (data != null) {
        Get.offAllNamed(Routes.AUTHENTICATE);
        Get.snackbar(
          'Success',
          'User deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future updateUserData() async {
    try {
      isLoading.value = true;
      final data = {
        'name': nameController.value.text,
        'email': emailController.value.text,
        'password': passwordController.value.text,
      };
      final id = await Constants.storage.read('id');
      final response = await updateUserDataProvider.updateUserData(id, data);
      if (response != null) {
        getCurrentUserData();
        Get.snackbar(
          'Success',
          'User updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await Constants.storage.remove('id');
    await Constants.storage.remove('token');
    Get.offAllNamed(Routes.AUTHENTICATE);
  }

  @override
  void onInit() {
    getCurrentUserData();
    super.onInit();
  }
}
