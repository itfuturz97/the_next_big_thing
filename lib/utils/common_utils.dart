import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';

class CommonUtil {
  Future<bool> isNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }
  }

  void goToNoInternetScreen() {
    String currentRoute = Get.currentRoute;
    if (currentRoute != AppRouteNames.noInternet) {
      Get.toNamed(AppRouteNames.noInternet);
    }
  }
}

CommonUtil commonUtil = CommonUtil();
