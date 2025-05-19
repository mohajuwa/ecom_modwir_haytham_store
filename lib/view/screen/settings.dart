// lib/view/screen/settings.dart
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/textstyle_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecom_modwir/controller/settings_controller.dart';
import 'package:ecom_modwir/controller/theme_controller.dart';
import 'package:ecom_modwir/core/constant/imgaeasset.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Design constants
  static const double kCardRadius = 24.0;
  static const double kIconSize = 22.0;
  static const double kAvatarSize = 40.0;
  static const double kHeaderHeight = 180.0;
  static const double kSpacing = 16.0;
  static const double kSectionSpacing = 32.0;
  static const double kDividerIndent = 56.0;
  static const Duration kAnimationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        strokeWidth: 2.5,
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          await controller.loadData();
        },
        child: GetBuilder<SettingsController>(
          builder: (controller) => CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, controller),
              SliverToBoxAdapter(child: SizedBox(height: kSectionSpacing)),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.onSecondary,
      scrolledUnderElevation: 4,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'settings'.tr,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        background: _buildProfileHeader(context, controller),
        titlePadding: const EdgeInsets.only(left: 24, bottom: 5),
        expandedTitleScale: 1.8,
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, SettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
          stops: const [0.4, 1.0],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Background decorative element
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile avatar with border and shadow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: 'profile_avatar',
                      child: _buildAvatar(context, controller),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // User info column
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => AnimatedSwitcher(
                              duration: kAnimationDuration,
                              switchInCurve: Curves.easeInOut,
                              child: Text(
                                controller.userName.value,
                                key: ValueKey(controller.userName.value),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        const SizedBox(height: 2),
                        Obx(() => AnimatedSwitcher(
                              duration: kAnimationDuration,
                              child: controller.userPhone.isEmpty
                                  ? const SizedBox(height: 4)
                                  : Text(
                                      controller.userPhone.value,
                                      key: ValueKey(controller.userPhone.value),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                          ),
                                    ),
                            )),
                        const SizedBox(height: 8),
                        if (!controller.isAuthenticated())
                          _buildLoginButton(context, controller)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, SettingsController controller) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.onPrimary,
            Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
          ],
        ),
      ),
      child: CircleAvatar(
        radius: kAvatarSize,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundImage: controller.isAuthenticated()
            ? AssetImage(AppImageAsset.avatar)
            : null,
        child: !controller.isAuthenticated()
            ? Icon(Icons.person,
                size: kAvatarSize - 5,
                color: Theme.of(context).colorScheme.onPrimaryContainer)
            : null,
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context, SettingsController controller) {
    return ElevatedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        controller.authService.showAuthDialog(context, onSuccess: () {
          controller.loadData();
          Get.forceAppUpdate();
        });
      },
      icon: Icon(
        Icons.login_rounded,
        size: 18,
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.onPrimary,
      ),
      label: Text(
        'tap_to_login'.tr,
        style: MyTextStyle.styleBold(context).copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(120, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
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

        // Orders section with real-time data
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
        const SizedBox(height: kSectionSpacing),
        _buildAppInfo(context),
        const SizedBox(height: kSectionSpacing * 2),
      ]),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, kSectionSpacing, 24, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
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
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor:
          Theme.of(context).colorScheme.surfaceTint.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
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
          trailing: _buildArrowButton(context),
          onTap: () {
            HapticFeedback.selectionClick();
            controller.navigateToProfile(context);
          },
        ),
        _buildAnimatedDivider(),
        _buildListTile(
          context,
          title: 'addresses'.tr,
          icon: Icons.location_on_outlined,
          trailing: _buildArrowButton(context),
          onTap: () {
            HapticFeedback.selectionClick();
            controller.navigateToAddresses(context);
          },
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
          onTap: () {
            HapticFeedback.selectionClick();
            controller.navigateToOrdersByStatus('pending', context);
          },
        ),
        _buildAnimatedDivider(),
        _buildListTile(
          context,
          title: 'archived_orders'.tr,
          icon: Icons.archive_outlined,
          trailing: Obx(() => _buildOrderBadge(
              context,
              controller.archivedOrdersCount.value,
              Theme.of(context).colorScheme.primary)),
          onTap: () {
            HapticFeedback.selectionClick();
            controller.navigateToOrdersByStatus('archived', context);
          },
        ),
        _buildAnimatedDivider(),
        _buildListTile(
          context,
          title: 'canceled_orders'.tr,
          icon: Icons.cancel_outlined,
          trailing: Obx(() => _buildOrderBadge(
              context,
              controller.canceledOrdersCount.value,
              Theme.of(context).colorScheme.error.withOpacity(0.8))),
          onTap: () {
            HapticFeedback.selectionClick();
            controller.navigateToOrdersByStatus('canceled', context);
          },
        ),
        _buildAnimatedDivider(),
        _buildListTile(
          context,
          title: 'all_orders'.tr,
          icon: Icons.list_alt_outlined,
          trailing: Obx(() {
            final total = controller.pendingOrdersCount.value +
                controller.archivedOrdersCount.value +
                controller.canceledOrdersCount.value;
            return _buildOrderBadge(
                context, total, Theme.of(context).colorScheme.primary);
          }),
          onTap: () {
            HapticFeedback.selectionClick();
            controller.navigateToOrdersByStatus('all', context);
          },
        ),
        if (controller.isAuthenticated()) ...[
          _buildAnimatedDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: Obx(() => AnimatedSwitcher(
                    duration: kAnimationDuration,
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary),
                            ),
                          )
                        : TextButton.icon(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              controller.refreshOrderCounts();
                            },
                            icon: Icon(
                              Icons.refresh_rounded,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: Text(
                              'refresh_orders'.tr,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.borderRadius),
                              ),
                            ),
                          ),
                  )),
            ),
          ),
        ],
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
          trailing: Obx(() => _buildAnimatedSwitch(
                context,
                value: themeController.themeMode.value == 'dark',
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  themeController.setThemeMode(value ? 'dark' : 'light');
                },
              )),
        ),
        _buildAnimatedDivider(),
        _buildListTile(
          context,
          title: 'use_system_theme'.tr,
          icon: Icons.brightness_auto,
          trailing: Obx(() => _buildAnimatedSwitch(
                context,
                value: themeController.themeMode.value == 'system',
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  themeController.setThemeMode(
                      value ? 'system' : (Get.isDarkMode ? 'dark' : 'light'));
                },
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
        // Language selector with animated selection
        _buildLanguageTile(
          context,
          controller,
          flagEmoji: '🇺🇸',
          language: 'english'.tr,
          value: 'en',
        ),
        _buildAnimatedDivider(),
        _buildLanguageTile(
          context,
          controller,
          flagEmoji: '🇸🇦',
          language: 'arabic'.tr,
          value: 'ar',
        ),
      ],
    );
  }

  Widget _buildLanguageTile(BuildContext context, SettingsController controller,
      {required String flagEmoji,
      required String language,
      required String value}) {
    return Obx(() {
      final isSelected = controller.currentLang.value == value;
      return InkWell(
        onTap: () {
          if (!isSelected) {
            HapticFeedback.selectionClick();
            controller.changeLang(value);
          }
        },
        borderRadius: BorderRadius.circular(kCardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: AnimatedContainer(
              duration: kAnimationDuration,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                flagEmoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            title: Text(
              language,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: kAnimationDuration,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      );
    });
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
          trailing: Obx(() => _buildAnimatedSwitch(
                context,
                value: controller.notificationsEnabled.value,
                onChanged: (value) {
                  HapticFeedback.selectionClick();
                  controller.toggleNotifications(value);
                },
              )),
        ),
        _buildAnimatedDivider(),
        _buildListTile(
          context,
          title: 'help_support'.tr,
          icon: Icons.help_outline_rounded,
          trailing: _buildArrowButton(context),
          onTap: () {
            HapticFeedback.selectionClick();
            controller.navigateToHelpSupport();
          },
        ),
        _buildAnimatedDivider(),
        _buildListTile(
          context,
          title: 'about_app'.tr,
          icon: Icons.info_outline_rounded,
          trailing: _buildArrowButton(context),
          onTap: () {
            HapticFeedback.selectionClick();
            _showAboutDialog(context);
          },
        ),
        if (controller.isAuthenticated()) ...[
          _buildAnimatedDivider(),
          _buildListTile(
            context,
            title: 'logout'.tr,
            icon: Icons.logout_rounded,
            iconColor: Theme.of(context).colorScheme.error,
            textColor: Theme.of(context).colorScheme.error,
            onTap: () {
              HapticFeedback.mediumImpact();
              _showLogoutDialog(context, controller);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 28,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ModWir',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'v1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            '© 2025 ModWir Team',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  // Modern platform adaptive switch with animation
  Widget _buildAnimatedSwitch(
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
    final thumbColor = Theme.of(context).colorScheme.surface;

    return AnimatedSwitcher(
      duration: kAnimationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: isIOS
          ? CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              trackColor: inactiveColor,
              thumbColor: thumbColor,
            )
          : Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              activeTrackColor: activeColor.withOpacity(0.4),
              inactiveThumbColor: thumbColor,
              inactiveTrackColor: inactiveColor,
            ),
    );
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kCardRadius),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          dense: false,
          minVerticalPadding: 16,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? Theme.of(context).colorScheme.primary)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Icon(
              icon,
              size: kIconSize,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: textColor ?? Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: trailing,
        ),
      ),
    );
  }

  Widget _buildArrowButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildOrderBadge(BuildContext context, int count, Color color) {
    if (count == 0) {
      return const SizedBox(width: 40);
    }

    return AnimatedContainer(
      duration: kAnimationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildAnimatedDivider() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value * 0.6,
          child: Divider(
            height: 1,
            thickness: 1,
            indent: kDividerIndent,
            endIndent: 0,
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        );
      },
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
            SizedBox(height: AppDimensions.mediumSpacing),
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
