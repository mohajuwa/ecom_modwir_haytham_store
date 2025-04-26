import 'package:ecom_modwir/core/constant/color.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportController extends GetxController {
  final expandedQuestions = <int>[].obs;

  void toggleQuestion(int index) {
    if (expandedQuestions.contains(index)) {
      expandedQuestions.remove(index);
    } else {
      expandedQuestions.add(index);
    }
  }

  bool isExpanded(int index) {
    return expandedQuestions.contains(index);
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar(
        'error'.tr,
        'could_not_launch_url'.tr,
        backgroundColor: AppColor.deleteColor.withOpacity(0.1),
      );
    }
  }
}
