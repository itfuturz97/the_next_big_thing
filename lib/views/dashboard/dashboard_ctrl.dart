import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/config/session.dart';
import 'package:the_next_big_thing/utils/storage.dart';

class DashboardCtrl extends GetxController {
  dynamic userData;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async => await getAPICalling());
  }

  Future<void> getAPICalling() async {
    userData = await read(AppSession.userData);
    update();
  }
}
