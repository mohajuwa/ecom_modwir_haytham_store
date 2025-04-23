import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controller/settings_controller.dart';
import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Design constants
  static const double kCardRadius = 16.0;
  static const double kIconSize = 24.0;
  static const double kAvatarSize = 42.0;
  static const double kHeaderHeight = 200.0;
  static const double kSpacing = 16.0;
  static const double kDividerIndent = 70.0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadData();
        },
        child: GetBuilder<SettingsController>(
          builder: (controller) => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(context, controller),
              SliverToBoxAdapter(child: SizedBox(height: kSpacing)),
              _buildSectionsList(context, controller, themeController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, SettingsController controller) {
    return SliverAppBar(
      expandedHeight: kHeaderHeight,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('settings'.tr),
        background: _buildProfileHeader(context, controller),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        expandedTitleScale: 1.5,
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kSpacing),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Profile avatar with border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: kAvatarSize,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: controller.isAuthenticated()
                      ? AssetImage(AppImageAsset.avatar)
                      : null,
                  child: !controller.isAuthenticated()
                      ? Icon(Icons.person,
                          size: kAvatarSize,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer)
                      : null,
                ),
              ),

              // User info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(
                        controller.userName.value,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Obx(() => controller.userPhone.isEmpty
                      ? SizedBox(height: 4)
                      : Text(
                          controller.userPhone.value,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.8),
                                  ),
                        )),
                  if (!controller.isAuthenticated())
                    TextButton(
                      onPressed: () {
                        // Create a new instance of AuthService if needed
                        // Show auth dialog and proceed with order after successful auth
                        controller.authService.showAuthDialog(context,
                            onSuccess: () {
                          // Just call loadData and force update
                          controller.loadData();
                          Get.forceAppUpdate(); // Force UI to refresh
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text('tap_to_login'.tr),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionsList(BuildContext context, SettingsController controller,
      ThemeController themeController) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Account section
        _buildSectionHeader(context, 'account'.tr, Icons.person_outline),
        _buildAccountSection(context, controller),

        // Orders section
        _buildSectionHeader(context, 'orders'.tr, Icons.receipt_long_outlined),
        _buildOrdersSection(context, controller),

        // Appearance section
        _buildSectionHeader(context, 'appearance'.tr, Icons.palette_outlined),
        _buildAppearanceSection(context, themeController),

        // Language section
        _buildSectionHeader(context, 'language'.tr, Icons.language),
        _buildLanguageSection(context, controller),

        // More section
        _buildSectionHeader(context, 'more_options'.tr, Icons.more_horiz),
        _buildMoreSection(context, controller),

        // App info section
        const SizedBox(height: kSpacing * 2),
        _buildAppInfo(context),
        const SizedBox(height: kSpacing * 4),
      ]),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildAccountSection(
      BuildContext context, SettingsController controller) {
    return _buildSettingsCard(
      context,
      children: [
        _buildListTile(
          context,
          title: 'profile'.tr,
          icon: Icons.person_outline,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => controller.navigateToProfile(),
        ),
        _buildDivider(),
        _buildListTile(
          context,
          title: 'addresses'.tr,
          icon: Icons.location_on_outlined,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => controller.navigateToAddresses(),
        ),
        _buildDivider(),
        _buildListTile(
          context,
          title: 'payment_methods'.tr,
          icon: Icons.credit_card_outlined,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => controller.navigateToPaymentMethods(),
        ),
      ],
    );
  }

  Widget _buildOrdersSection(
      BuildContext context, SettingsController controller) {
    return _buildSettingsCard(
      context,
      children: [
        _buildListTile(
          context,
          title: 'pending_orders'.tr,
          icon: Icons.watch_later_outlined,
          trailing: Obx(() => _buildOrderBadge(
              context, controller.pendingOrdersCount.value, Colors.amber)),
          onTap: () => controller.navigateToOrdersByStatus('pending'),
        ),
        _buildDivider(),
        _buildListTile(
          context,
          title: 'archived_orders'.tr,
          icon: Icons.archive_outlined,
          trailing: Obx(() => _buildOrderBadge(
              context,
              controller.archivedOrdersCount.value,
              Theme.of(context).colorScheme.primary)),
          onTap: () => controller.navigateToOrdersByStatus('archived'),
        ),
        _buildDivider(),
        _buildListTile(
          context,
          title: 'canceled_orders'.tr,
          icon: Icons.cancel_outlined,
          trailing: Obx(() => _buildOrderBadge(
              context,
              controller.canceledOrdersCount.value,
              Theme.of(context).colorScheme.error)),
          onTap: () => controller.navigateToOrdersByStatus('canceled'),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(
      BuildContext context, ThemeController themeController) {
    return _buildSettingsCard(
      context,
      children: [
        _buildListTile(
          context,
          title: 'dark_mode'.tr,
          icon: Icons.dark_mode_outlined,
          trailing: Obx(() => _buildPlatformSwitch(
                context,
                value: themeController.themeMode.value == 'dark',
                onChanged: (value) =>
                    themeController.setThemeMode(value ? 'dark' : 'light'),
              )),
        ),
        _buildDivider(),
        _buildListTile(
          context,
          title: 'use_system_theme'.tr,
          icon: Icons.brightness_auto,
          trailing: Obx(() => _buildPlatformSwitch(
                context,
                value: themeController.themeMode.value == 'system',
                onChanged: (value) => themeController.setThemeMode(
                    value ? 'system' : (Get.isDarkMode ? 'dark' : 'light')),
              )),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(
      BuildContext context, SettingsController controller) {
    return _buildSettingsCard(
      context,
      children: [
        // Wrap only the radio button in Obx to minimize reactivity scope
        ListTile(
          title: const Text('English'),
          subtitle: const Text('en'),
          leading: const Text('🇺🇸'),
          trailing: Obx(() => Radio<String>(
                value: 'en',
                groupValue: controller.currentLang.value,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) => controller.changeLang(value!),
              )),
        ),
        _buildDivider(),
        ListTile(
          title: const Text('العربية'),
          subtitle: const Text('ar'),
          leading: const Text('🇸🇦'),
          trailing: Obx(() => Radio<String>(
                value: 'ar',
                groupValue: controller.currentLang.value,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) => controller.changeLang(value!),
              )),
        ),
      ],
    );
  }

  Widget _buildMoreSection(
      BuildContext context, SettingsController controller) {
    return _buildSettingsCard(
      context,
      children: [
        _buildListTile(
          context,
          title: 'notifications'.tr,
          icon: Icons.notifications_outlined,
          trailing: Obx(() => _buildPlatformSwitch(
                context,
                value: controller.notificationsEnabled.value,
                onChanged: (value) => controller.toggleNotifications(value),
              )),
        ),
        _buildDivider(),
        _buildListTile(
          context,
          title: 'help_support'.tr,
          icon: Icons.help_outline,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => controller.navigateToHelpSupport(),
        ),
        _buildDivider(),
        _buildListTile(
          context,
          title: 'about_app'.tr,
          icon: Icons.info_outline,
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showAboutDialog(context),
        ),
        if (controller.isAuthenticated()) ...[
          _buildDivider(),
          _buildListTile(
            context,
            title: 'logout'.tr,
            icon: Icons.logout,
            iconColor: Theme.of(context).colorScheme.error,
            textColor: Theme.of(context).colorScheme.error,
            onTap: () => _showLogoutDialog(context, controller),
          ),
        ],
      ],
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'ModWir',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'v1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  // Platform adaptive switch that looks good on both iOS and Android
  Widget _buildPlatformSwitch(
    BuildContext context, {
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    // Determine if we're on iOS
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Define common colors
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[700]
        : Colors.grey[300];
    final thumbColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.white;

    if (isIOS) {
      // iOS-styled switch
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        trackColor: inactiveColor,
        thumbColor: thumbColor,
      );
    } else {
      // Material-styled switch
      return Switch(
        value: value,
        onChanged: onChanged,
        activeColor: thumbColor,
        activeTrackColor: activeColor,
        inactiveThumbColor: thumbColor,
        inactiveTrackColor: inactiveColor,
      );
    }
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon,
          size: kIconSize,
          color: iconColor ?? Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildOrderBadge(BuildContext context, int count, Color color) {
    if (count == 0) {
      return const SizedBox(width: 40);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: kDividerIndent,
      endIndent: 0,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('about_app'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('app_description'.tr),
            const SizedBox(height: 16),
            Text('${'version'.tr}: 1.0.0'),
            Text('${'developed_by'.tr}: ModWir Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, SettingsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout_confirmation'.tr),
        content: Text('logout_confirmation_message'.tr),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              Navigator.pop(context);
              controller.logout();
            },
            child: Text('logout'.tr),
          ),
        ],
      ),
    );
  }
}
