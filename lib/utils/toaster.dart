import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  Future<bool?> success(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<bool?> warning(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.amber,
      textColor: Colors.black,
      fontSize: 14.0,
    );
  }

  Future<bool?> error(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<bool?> info(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

Toaster toaster = Toaster();
