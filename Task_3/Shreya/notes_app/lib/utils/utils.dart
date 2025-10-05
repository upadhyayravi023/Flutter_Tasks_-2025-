import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:another_flushbar/flushbar.dart';

class Utils{
  static toastMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.grey,
    );
  }
  static void flushBarErrorMessage(String message,BuildContext context) {
    showFlushbar(context: context, flushbar: Flushbar(
        message: message,
        backgroundColor: Colors.red,
        title: "Error!",
        messageColor: Colors.white,
        duration: Duration(seconds: 5),
    )
      ..show(context),
    );
  }

    static snackBar(String message,BuildContext context){
      return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      backgroundColor: Colors.red,
      )
      );
    }


}

