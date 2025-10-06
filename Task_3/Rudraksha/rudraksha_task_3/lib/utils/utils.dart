import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import'package:fluttertoast/fluttertoast.dart';

class Utils{
  static toastMessage(String message){
    Fluttertoast.showToast(msg: message);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(context: context,
      flushbar: Flushbar(
        message: message,
        flushbarStyle: FlushbarStyle.FLOATING,
        isDismissible: true,
      )..show(context),
    );
  }
}

