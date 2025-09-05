import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/config/session.dart';
import 'package:the_next_big_thing/utils/helper.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/service/notification_service.dart';
import 'package:the_next_big_thing/utils/storage.dart';
import 'package:the_next_big_thing/utils/toaster.dart';
import 'package:the_next_big_thing/views/auth/auth_service.dart';

class LoginCtrl extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var isGuestLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  final TextEditingController mobileController = TextEditingController();

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading(true);
    try {
      final getToken = await notificationService.getToken();
      final deviceId = await helper.getDeviceUniqueId();
      final body = {'mobile_number': mobileController.text, 'fcm': getToken, 'deviceId': deviceId};
      final response = await _authService.login(body);
      if (response != null) {
        if (response["message"] == "Verification code sent on mobile number") {
          toaster.success("Login successful!");
          Get.toNamed(AppRouteNames.verification, arguments: {'mobile_number': mobileController.text});
        } else {
          await write(AppSession.userData, response["user"]);
          await write(AppSession.token, response["token"]);
          Get.offAllNamed(AppRouteNames.dashboard);
        }
      } else {
        toaster.error(response?.message ?? "Login failed!");
      }
    } catch (e) {
      toaster.error("An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  void guestLogin() async {
    isGuestLoading(true);
    try {
      toaster.success("Logged in as guest!");
      Get.offAllNamed(AppRouteNames.dashboard);
    } catch (e) {
      toaster.error("Guest login failed: $e");
    } finally {
      isGuestLoading(false);
    }
  }

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }
}
