// lib/view/widget/customappbar.dart (or your file path)
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/core/constant/routes.dart';
import 'package:ecom_modwir/view/widget/notification_badge.dart'; // Assuming this is your custom widget
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions; // Added actions parameter

  const CustomAppBar({
    super.key,
    this.title,
    this.actions, // Added to constructor
  });

  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight + 12); // Keep existing preferred size

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme for consistency

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      toolbarHeight: kToolbarHeight + 12,
      automaticallyImplyLeading: false, // No back button by default
      titleSpacing: AppDimensions
          .screenPadding, // Use screen padding for consistent title spacing
      title: Container(
        // This container acts as the main content area for the AppBar's title slot
        // It will hold the title, notification icon, and any custom actions.
        // Removed fixed padding from here to allow Row to manage spacing
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // Use theme surface color
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.mediumPadding,
            vertical:
                AppDimensions.smallPadding), // Apply padding to the container
        child: Row(
          children: [
            // Back button if navigation stack allows and no custom leading is implied
            if (Navigator.canPop(context))
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new,
                    color: theme.colorScheme.onSurface,
                    size: AppDimensions.defaultIconSize - 2),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Get.back(),
              ),
            if (Navigator.canPop(context) &&
                (title != null && title!.isNotEmpty))
              const SizedBox(
                  width: AppDimensions
                      .smallSpacing), // Spacing after back button if title exists

            // Title
            if (title != null && title!.isNotEmpty)
              Expanded(
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18, // Consistent font size
                    fontFamily: 'Khebrat',
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600, // Slightly bolder title
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long titles
                ),
              ),
            if (title == null ||
                title!
                    .isEmpty) // If no title, add a spacer to push icons to the right
              const Spacer(),

            // Custom Actions (if provided)
            if (actions != null && actions!.isNotEmpty) ...actions!,

            // Notification Badge (always present, to the right of actions or title)
            // Add some spacing if actions are present
            if (actions != null && actions!.isNotEmpty)
              const SizedBox(width: AppDimensions.smallSpacing / 2),

            NotificationBadge(
              // Your existing notification badge
              onPressed: () => Get.toNamed(AppRoute.notifications),
              child: Container(
                // Keeping your original container for the icon
                padding: const EdgeInsets.all(
                    AppDimensions.smallPadding), // Consistent padding
                // Removed redundant decoration, NotificationBadge might handle it or use a simpler one
                child: FaIcon(
                  FontAwesomeIcons.bell,
                  color: theme.colorScheme.primary, // Use theme primary color
                  size:
                      AppDimensions.defaultIconSize - 2, // Consistent icon size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
