import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/utils/common_utils.dart';
import 'package:the_next_big_thing/utils/config/session.dart';
import 'package:the_next_big_thing/utils/network/api_config.dart';
import 'package:the_next_big_thing/utils/routes/route_name.dart';
import 'package:the_next_big_thing/utils/storage.dart';
import 'package:the_next_big_thing/utils/toaster.dart';
import 'package:the_next_big_thing/views/splash/splash_ctrl.dart';

Dio dio = Dio();

class ApiManager {
  ApiManager() {
    dio.options
      ..baseUrl = APIConfig.apiBaseURL
      ..connectTimeout = const Duration(milliseconds: 20000)
      ..receiveTimeout = const Duration(milliseconds: 20000)
      ..validateStatus = (int? status) {
        return status! > 0;
      }
      ..headers = {'Accept': 'application/json', 'content-type': 'application/json'};
  }

  Future<dynamic> post(String apiName, body) async {
    bool isInternet = await commonUtil.isNetworkConnection();
    if (isInternet) {
      try {
        String token = await read(AppSession.token) ?? "";
        if (token.isNotEmpty) {
          dio.options.headers["Authorization"] = "Bearer $token";
        }
        if (kDebugMode) {
          print("Api Name :${APIConfig.apiBaseURL}$apiName");
          print("AuthToken :${dio.options.headers["Authorization"]}");
          print("Request :$body");
        }
        final response = await dio.post(apiName, data: body);
        log("Response...$response");
        return response.data;
      } on DioException catch (err) {
        if (err.type == DioExceptionType.badResponse) {
          if (err.response?.statusCode == 401) {
            _errorThrow(err);
            await clearStorage();
            Get.offNamedUntil(AppRouteNames.splash, (Route<dynamic> route) => false);
            Get.put(SplashCtrl(), permanent: true).onReady();
            toaster.error("Something went wrong server error ${err.response?.statusCode}!");
            return null;
          } else {
            _errorThrow(err);
            toaster.error("Something went wrong server error ${err.response?.statusCode}!");
            return null;
          }
        } else if (err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
          _errorThrow(err);
          toaster.error("Request timeout 408");
          return null;
        } else {
          _errorThrow(err);
          toaster.error("Something went wrong server error ${err.response?.statusCode}!");
          return null;
        }
      } catch (err) {
        return null;
      }
    } else {
      commonUtil.goToNoInternetScreen();
      return null;
    }
  }

  Future<void> _errorThrow(DioException err) async {
    if (err.response != null) {
      dynamic userData = await read(AppSession.userData);
      var errorShow = {"Api": err.response!.realUri, "Status": err.response!.statusCode, "UserName": userData["name"] ?? "", "StatusMessage": err.response!.statusMessage};
      await FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(exception: errorShow));
      throw Exception(errorShow);
    }
  }
}
