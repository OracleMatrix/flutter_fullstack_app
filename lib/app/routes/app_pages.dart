import 'package:get/get.dart';

import '../modules/Authenticate/bindings/authenticate_binding.dart';
import '../modules/Authenticate/views/authenticate_view.dart';
import '../modules/Splash/bindings/splash_binding.dart';
import '../modules/Splash/views/splash_view.dart';
import '../modules/home/SocialMedia/bindings/social_media_binding.dart';
import '../modules/home/SocialMedia/views/social_media_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.SOCIAL_MEDIA,
          page: () => const SocialMediaView(),
          binding: SocialMediaBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.AUTHENTICATE,
      page: () => const AuthenticateView(),
      binding: AuthenticateBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
