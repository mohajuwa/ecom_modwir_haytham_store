import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtonAppBar extends StatelessWidget {
  final void Function()? onPressed;
  final String textbutton;
  final IconData icondata;
  final bool active;

  const CustomButtonAppBar({
    super.key,
    required this.textbutton,
    required this.icondata,
    required this.onPressed,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.getResponsiveHeight(
            context,
            10,
            minHeight: 8,
            maxHeight: 14,
          ),
          horizontal: AppDimensions.getResponsiveWidth(
            context,
            20,
            minWidth: 12,
            maxWidth: 28,
          ),
        ),
        decoration: BoxDecoration(
          color: active
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icondata,
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              size: AppDimensions.getResponsiveWidth(
                context,
                AppDimensions.defaultIconSize,
                minWidth: AppDimensions.smallButtonIconSize,
                maxWidth: AppDimensions.iconSize,
              ),
            ),
            SizedBox(
              height: AppDimensions.getResponsiveHeight(
                context,
                3,
                minHeight: 2,
                maxHeight: 5,
              ),
            ),
            Text(
              textbutton.tr,
              style: TextStyle(
                fontSize: AppDimensions.getResponsiveWidth(
                  context,
                  10,
                  minWidth: 8,
                  maxWidth: 12,
                ),
                fontWeight: FontWeight.normal,
                fontFamily: 'Khebrat',
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
