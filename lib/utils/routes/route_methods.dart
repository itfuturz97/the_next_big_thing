import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/views/auth/intro/intro.dart';
import 'package:the_next_big_thing/views/auth/login/login.dart';
import 'package:the_next_big_thing/views/auth/register/register.dart';
import 'package:the_next_big_thing/views/auth/verification/verification.dart';
import 'package:the_next_big_thing/views/dashboard/dashboard.dart';
import 'package:the_next_big_thing/views/dashboard/profile/profile.dart';
import 'package:the_next_big_thing/views/no_internet.dart';
import 'package:the_next_big_thing/views/notifications/notifications.dart';
import 'package:the_next_big_thing/views/auth/splash/splash.dart';

class AppRouteMethods {
  static GetPage<dynamic> getPage({required String name, required GetPageBuilder page, List<GetMiddleware>? middlewares}) {
    return GetPage(name: name, page: page, transition: Transition.topLevel, showCupertinoParallax: true, middlewares: middlewares ?? [], transitionDuration: 350.milliseconds);
  }

  static List<GetPage> pages = [
    getPage(name: AppRouteNames.splash, page: () => const Splash()),
    getPage(name: AppRouteNames.intro, page: () => const Intro()),
    getPage(name: AppRouteNames.login, page: () => const Login()),
    getPage(name: AppRouteNames.register, page: () => const Register()),
    getPage(name: AppRouteNames.verification, page: () => const Verification()),
    getPage(name: AppRouteNames.noInternet, page: () => const NoInternet()),
    getPage(name: AppRouteNames.dashboard, page: () => const Dashboard()),
    getPage(name: AppRouteNames.profile, page: () => const Profile()),
    getPage(name: AppRouteNames.notifications, page: () => const Notifications()),
  ];
}
