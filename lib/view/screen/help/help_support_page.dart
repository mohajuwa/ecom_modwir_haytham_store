// lib/view/screen/help/help_support_page.dart
import 'package:ecom_modwir/controller/help_support_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/color.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportPage extends GetView<HelpSupportController> {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HelpSupportController());

    return Scaffold(
      appBar: AppBar(
        title: Text('help_support'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact options
            _buildSection(
              context: context,
              title: 'contact_us'.tr,
              children: [
                _buildContactItem(
                  context: context,
                  icon: Icons.email_outlined,
                  title: 'email'.tr,
                  subtitle: 'support@modwir.com',
                  onTap: () =>
                      controller.launchURL('mailto:support@modwir.com'),
                ),
                _buildContactItem(
                  context: context,
                  icon: Icons.phone_outlined,
                  title: 'phone'.tr,
                  subtitle: '+966 123 456 789',
                  onTap: () => controller.launchURL('tel:+966123456789'),
                ),
                _buildContactItem(
                  context: context,
                  icon: Icons.chat_outlined,
                  title: 'live_chat'.tr,
                  subtitle: 'chat_with_support_team'.tr,
                  onTap: () {
                    // Implement live chat functionality
                    Get.snackbar(
                      'coming_soon'.tr,
                      'feature_available_soon'.tr,
                      backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: AppDimensions.largeSpacing),

            // FAQs
            _buildSection(
              context: context,
              title: 'frequently_asked_questions'.tr,
              children: [
                _buildQuestion(
                  context: context,
                  index: 0,
                  question: 'how_to_add_vehicle'.tr,
                  answer: 'go_to_my_vehicles_and_tap'.tr,
                ),
                _buildQuestion(
                  context: context,
                  index: 1,
                  question: 'how_to_make_order'.tr,
                  answer: 'select_service_then_vehicle'.tr,
                ),
                _buildQuestion(
                  context: context,
                  index: 2,
                  question: 'payment_methods_question'.tr,
                  answer: 'we_accept_cash_and_cards'.tr,
                ),
                _buildQuestion(
                  context: context,
                  index: 3,
                  question: 'cancel_order_question'.tr,
                  answer: 'go_to_orders_and_select_cancel'.tr,
                ),
              ],
            ),

            SizedBox(height: AppDimensions.largeSpacing),

            // Additional help options
            _buildSection(
              context: context,
              title: 'additional_resources'.tr,
              children: [
                _buildListTile(
                  context: context,
                  title: 'terms_and_conditions'.tr,
                  icon: Icons.description_outlined,
                  onTap: () => Get.toNamed('/terms'),
                ),
                _buildListTile(
                  context: context,
                  title: 'privacy_policy'.tr,
                  icon: Icons.privacy_tip_outlined,
                  onTap: () => Get.toNamed('/privacy'),
                ),
                _buildListTile(
                  context: context,
                  title: 'about_us'.tr,
                  icon: Icons.info_outline,
                  onTap: () => Get.toNamed('/about'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: MyTextStyle.styleBold(context).copyWith(
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: AppDimensions.mediumSpacing),
        ...children,
      ],
    );
  }

  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColor.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: MyTextStyle.meduimBold(context),
                    ),
                    Text(
                      subtitle,
                      style: MyTextStyle.bigCapiton(context),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required BuildContext context,
    required int index,
    required String question,
    required String answer,
  }) {
    return Obx(() => Column(
          children: [
            InkWell(
              onTap: () => controller.toggleQuestion(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: MyTextStyle.meduimBold(context),
                      ),
                    ),
                    Icon(
                      controller.isExpanded(index)
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColor.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isExpanded(index))
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  answer,
                  style: MyTextStyle.bigCapiton(context),
                ),
              ),
            Divider(color: Theme.of(context).dividerColor),
          ],
        ));
  }

  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColor.primaryColor),
      title: Text(title, style: MyTextStyle.meduimBold(context)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      onTap: onTap,
    );
  }
}
