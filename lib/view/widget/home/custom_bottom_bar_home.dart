import 'package:ecom_modwir/controller/homescreen_controller.dart';
import 'package:ecom_modwir/core/constant/app_dimensions.dart';
import 'package:ecom_modwir/view/widget/home/custom_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomAppBarHome extends StatelessWidget {
  const CustomBottomAppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenControllerImp>(
      builder: (controller) => Container(
        height: AppDimensions.getResponsiveHeight(
          context,
          110,
          minHeight: 90,
          maxHeight: 130,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: AppDimensions.getPixelRatioAdjustedValue(context, 10),
              spreadRadius: AppDimensions.getPixelRatioAdjustedValue(context, 1),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
            topRight: Radius.circular(AppDimensions.borderRadiusLarge),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
            topRight: Radius.circular(AppDimensions.borderRadiusLarge),
          ),
          child: BottomAppBar(
            color: Theme.of(context).colorScheme.surface,
            shape: const CircularNotchedRectangle(),
            notchMargin: AppDimensions.smallSpacing,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.getResponsiveWidth(
                  context,
                  AppDimensions.smallSpacing,
                  minWidth: AppDimensions.extraSmallSpacing,
                  maxWidth: AppDimensions.mediumSpacing,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(controller.bottomappbar.length, (index) {
                  return Expanded(
                    child: CustomButtonAppBar(
                      textbutton: controller.bottomappbar[index]['title'],
                      icondata: controller.bottomappbar[index]['icon'],
                      onPressed: () {
                        controller.changePage(index);
                      },
                      active: controller.currentpage == index,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}