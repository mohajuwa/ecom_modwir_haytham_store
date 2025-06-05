import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> alertExitApp(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("alert".tr,
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.normal)),
            content: Text("question_exit_from_app".tr),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("cancel".tr, style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("confirm".tr, style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      ) ??
      false;
}

// Usage example:
// WillPopScope(
//   onWillPop: () async {
//     final shouldExit = await alertExitApp(context);
//     if (shouldExit) exit(0);
//     return false;
//   },
//   child: YourScreenContent(),
// )
void showRemoveConfirmation(
  final VoidCallback? onPressed,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("confirm_remove".tr),
        content: Text("q_to_remove".tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text("cancel".tr, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog first
              onPressed?.call(); // Execute the delete action
            },
            child: Text("remove".tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
