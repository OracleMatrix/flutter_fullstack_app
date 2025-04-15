import 'package:flutter/material.dart';
import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    checkLogin();
    super.onInit();
  }

  void checkLogin() async {
    try {
      final token = await Constants.storage.read("token");
      if (token != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.AUTHENTICATE);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }
}
