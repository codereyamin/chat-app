import 'package:flutter/material.dart';

class UIHelper {
  static void showLodingDilog(BuildContext context, String title) {
    AlertDialog loadingDilog = AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 30,
            ),
            Text(
              // "Loading.....?",
              title,
              style: const TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => loadingDilog,
    );
  }

  static void showAlertDilog(
      BuildContext context, String title, String content) {
    AlertDialog alertDilog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alertDilog,
    );
  }
}
