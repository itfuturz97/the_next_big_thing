import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/config/session.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/storage.dart';

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isFirstTime = await read(AppSession.isFirstTime) ?? true;
    if (isFirstTime) {
      Get.offAllNamed(AppRouteNames.intro);
    } else {
      String token = await read(AppSession.token) ?? "";
      if (token.isNotEmpty) {
        Get.offAllNamed(AppRouteNames.dashboard);
      } else {
        Get.offAllNamed(AppRouteNames.login);
      }
    }
  }
}