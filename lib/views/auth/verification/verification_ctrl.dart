import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/config/session.dart';
import 'package:the_next_big_thing/utils/helper.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/service/notification_service.dart';
import 'package:the_next_big_thing/utils/storage.dart';
import 'package:the_next_big_thing/utils/toaster.dart';
import 'package:the_next_big_thing/views/auth/auth_service.dart';

class VerificationCtrl extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var otp = ''.obs;
  String mobileNumber = '';

  @override
  void onInit() {
    super.onInit();
    mobileNumber = Get.arguments?['mobile_number'] ?? '';
    if (mobileNumber.isEmpty) {
      toaster.error("Mobile number not provided");
      Get.back();
    }
  }

  void verifyOtp() async {
    if (otp.value.length != 4 || !RegExp(r'^[0-9]+$').hasMatch(otp.value)) {
      toaster.error("Please enter a valid 6-digit OTP");
      return;
    }
    isLoading(true);
    try {
      final getToken = await notificationService.getToken();
      final deviceId = await helper.getDeviceUniqueId();
      final body = {'mobile_number': mobileNumber, 'otpCode': otp.value, 'fcm': getToken, 'deviceId': deviceId};
      final response = await _authService.verifyMobile(body);
      if (response != null && response["success"] == true) {
        toaster.success("Verification successful!");
        await write(AppSession.userData, response["user"]);
        await write(AppSession.token, response["token"]);
        Get.offAllNamed(AppRouteNames.dashboard);
      } else {
        toaster.error(response?["error"] ?? "Verification failed!");
      }
    } catch (e) {
      toaster.error("An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  void resendOtp() async {
    try {
      final getToken = await notificationService.getToken();
      final deviceId = await helper.getDeviceUniqueId();
      final body = {'mobile_number': mobileNumber, 'fcm': getToken, 'deviceId': deviceId};
      final response = await _authService.login(body);
      if (response != null && response["message"] == "Verification code sent on mobile number") {
        toaster.success("OTP resent successfully!");
      } else {
        toaster.error("Failed to resend OTP");
      }
    } catch (e) {
      toaster.error("An error occurred: $e");
    }
  }
}
