import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/config/session.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/storage.dart';

class SplashCtrl extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    String token = await read(AppSession.token) ?? "";
    if (token.isNotEmpty) {
      Get.offAllNamed(AppRouteNames.dashboard);
    } else {
      Get.offAllNamed(AppRouteNames.login);
    }
  }
}
