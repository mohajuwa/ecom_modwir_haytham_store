// loading_utils.dart
import 'dart:async';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/functions/snack_bar_notif.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingUtils {
  static Timer? _loadingTimer;

  // Generic timeout handler
  static Timer handleLoadingTimeout({
    required VoidCallback onTimeout,
    int timeoutSeconds = 5,
  }) {
    _loadingTimer?.cancel();
    return _loadingTimer = Timer(Duration(seconds: timeoutSeconds), onTimeout);
  }

  // Reusable async task runner with timeout handling
  static Future<void> runWithTimeout({
    required Future<void> Function() task,
    required RxBool isLoading,
    int timeoutSeconds = 5,
    String timeoutMessage = 'request_timed_out',
  }) async {
    isLoading.value = true;
    final timer = handleLoadingTimeout(
      timeoutSeconds: timeoutSeconds,
      onTimeout: () {
        isLoading.value = false;
        showErrorSnackbar('error'.tr, timeoutMessage.tr);
      },
    );

    try {
      await task();
    } finally {
      timer.cancel();
      isLoading.value = false;
    }
  }
}
