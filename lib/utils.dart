import 'package:flutter/material.dart';

class Utils {
  static Future<dynamic> dialogLoaderForDynamicFuture(
    BuildContext cx,
    Future<dynamic>? future, {
    String? message,
  }) async {
    return await showDialog(
      context: cx,
      barrierDismissible: true,
      builder: (ctx) {
        future?.then(
          (value) => Navigator.pop(ctx, value),
        );
        return alertLoader(message: message);
      },
    );
  }

  static AlertDialog alertLoader({String? message}) => AlertDialog(
        insetPadding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: loaderWidget(message: message),
      );

  static Widget loaderWidget({
    String? message,
  }) =>
      Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              message ?? "Please Wait..",
            ),
          ),
        ],
      );
}
