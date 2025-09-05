import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/helper.dart';
import 'package:the_next_big_thing/utils/service/notification_service.dart';
import 'package:the_next_big_thing/utils/toaster.dart';
import 'package:the_next_big_thing/views/auth/auth_service.dart';

class RegisterCtrl extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessCategoryController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();

  File? profilePicPath;
  Map<String, dynamic>? business, socialMedia;

  void register() async {
    isLoading(true);
    try {
      if (!formKey.currentState!.validate()) {
        isLoading(false);
        return;
      }
      final getToken = await notificationService.getToken();
      final deviceId = await helper.getDeviceUniqueId();
      Map<String, dynamic> json = {
        'name': nameController.text,
        'email': emailController.text,
        'mobile_number': mobileController.text,
        'date_of_birth': dobController.text,
        'city': cityController.text,
        'state': stateController.text,
        'country': countryController.text,
        'fcm': getToken,
        'deviceId': deviceId,
      };
      if (businessNameController.text.isNotEmpty || businessCategoryController.text.isNotEmpty) {
        Map<String, dynamic> businessInfo = {};
        if (businessNameController.text.isNotEmpty) {
          businessInfo['business_name'] = businessNameController.text;
        }
        if (businessCategoryController.text.isNotEmpty) {
          businessInfo['category'] = businessCategoryController.text;
        }
        json["business"] = jsonEncode(businessInfo);
      }

      Map<String, dynamic> socialMediaInfo = {};
      if (facebookController.text.isNotEmpty) {
        socialMediaInfo['Facebook'] = facebookController.text;
      }
      if (instagramController.text.isNotEmpty) {
        socialMediaInfo['Instagram'] = instagramController.text;
      }
      if (twitterController.text.isNotEmpty) {
        socialMediaInfo['Twitter'] = twitterController.text;
      }
      if (linkedinController.text.isNotEmpty) {
        socialMediaInfo['LinkedIn'] = linkedinController.text;
      }
      if (socialMediaInfo.isNotEmpty) {
        json["SocialMedia"] = jsonEncode(socialMediaInfo);
      }
      if (addressController.text.isNotEmpty) {
        json["address"] = addressController.text;
      }
      log(json.toString());
      dio.FormData formData = dio.FormData.fromMap(json);
      if (profilePicPath != null) {
        String path = profilePicPath!.path;
        String imageName = profilePicPath!.path.split('/').last;
        formData.files.add(MapEntry("profilePic", await dio.MultipartFile.fromFile(path, filename: imageName.toString())));
      }
      final response = await _authService.register(formData);
      if (response != null && response["success"] == true) {
        toaster.success("Registration successful!");
        Get.back();
      } else {
        toaster.warning(response?["error"] ?? "Registration failed!");
      }
    } catch (e) {
      toaster.error("An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dobController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    addressController.dispose();
    businessNameController.dispose();
    businessCategoryController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    linkedinController.dispose();
    super.onClose();
  }
}
