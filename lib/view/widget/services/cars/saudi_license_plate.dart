import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:ecom_modwir/controller/license_plate_controller.dart';

import 'package:ecom_modwir/core/constant/color.dart';

import 'package:ecom_modwir/core/constant/textstyle_manger.dart';

class ModernSaudiLicensePlate extends StatelessWidget {
  final bool isDark;
  ModernSaudiLicensePlate({super.key, required this.isDark}) {
    // Use lazyPut instead of put for better memory management
    Get.lazyPut(() => LicensePlateController(), fenix: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LicensePlateController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'license_plate'.tr,
                style: MyTextStyle.meduimBold(context),
              ),
              _ClearButton(controller: controller, isDark: isDark),
            ],
          ),
          const SizedBox(height: 8),
          _LicensePlateContainer(controller: controller, isDark: isDark),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final LicensePlateController controller;

  final bool isDark;

  const _ClearButton({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: controller.clearAll,
      icon: Icon(
        Icons.clear,
        size: 16,
        color: isDark ? Colors.grey[400] : AppColor.grey2,
      ),
      label: Text(
        'clear'.tr,
        style: TextStyle(
          color: isDark ? Colors.grey[400] : AppColor.grey2,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
      ),
    );
  }
}

class _LicensePlateContainer extends StatelessWidget {
  final LicensePlateController controller;

  final bool isDark;

  const _LicensePlateContainer({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    String language = controller.lang.toString();

    bool isArabic = language == "ar";

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? Colors.grey[600]! : AppColor.blackColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : AppColor.blackColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _KSAEmblemSection(controller: controller, isDark: isDark),
            _LettersSection(controller: controller, isDark: isDark),
            _NumbersSection(controller: controller, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _LettersSection extends StatelessWidget {
  final LicensePlateController controller;

  final bool isDark;

  const _LettersSection({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    String language = controller.lang.toString();

    bool isArabic = language == "ar";

    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: isArabic
              ? Border(
                  left: BorderSide(
                    color: isDark ? Colors.grey[600]! : AppColor.blackColor,
                    width: 3,
                  ),
                )
              : Border(
                  right: BorderSide(
                    color: isDark ? Colors.grey[600]! : AppColor.blackColor,
                    width: 3,
                  ),
                ),
        ),
        child: Column(
          children: [
            // Arabic letters field

            _BidirectionalField(
              value: controller.arabicLetters,
              onChanged: controller.handleArabicLettersInput,
              style: MyTextStyle.notBold(
                context,
                letterSpacing: 5,
              ),
              hint: 'أ ب ج',
              isDark: isDark,
            ),

            Divider(
                color: isDark ? Colors.grey[600] : AppColor.blackColor,
                thickness: 2,
                height: 30),

            // English letters field

            _BidirectionalField(
              value: controller.englishLetters,
              onChanged: controller.handleEnglishLettersInput,
              style: MyTextStyle.notBold(
                context,
                letterSpacing: 3,
              ),
              hint: 'A B C',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumbersSection extends StatelessWidget {
  final LicensePlateController controller;

  final bool isDark;

  const _NumbersSection({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            // Arabic numbers field

            _BidirectionalField(
              value: controller.arabicNumbers,
              onChanged: controller.handleArabicNumbersInput,
              style: MyTextStyle.notBold(
                context,
                letterSpacing: 3,
              ),
              hint: '١ ٢ ٣ ٤',
              keyboardType: TextInputType.number,
              isDark: isDark,
            ),

            Divider(
                color: isDark ? Colors.grey[600] : AppColor.blackColor,
                thickness: 2,
                height: 30),

            // English numbers field

            _BidirectionalField(
              value: controller.englishNumbers,
              onChanged: controller.handleEnglishNumbersInput,
              style: MyTextStyle.notBold(
                context,
                letterSpacing: 3,
              ),
              hint: '1 2 3 4',
              keyboardType: TextInputType.number,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _BidirectionalField extends StatelessWidget {
  final String value;

  final ValueChanged<String> onChanged;

  final TextStyle style;

  final String hint;

  final TextInputType? keyboardType;

  final bool isDark;

  const _BidirectionalField({
    required this.value,
    required this.onChanged,
    required this.style,
    required this.hint,
    required this.isDark,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        onChanged: (newValue) {
          onChanged(newValue.replaceAll(' ', ''));
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[\S ]')),
        ],
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: value,
            selection: TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          ),
        ),
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: style,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[700] : AppColor.grey,
          ),
          counterText: '',
          isDense: true,
        ),
      ),
    );
  }
}

class _KSAEmblemSection extends StatelessWidget {
  final LicensePlateController controller;

  final bool isDark;

  const _KSAEmblemSection({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    String language = controller.lang.toString();

    bool isArabic = language == "ar";

    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: isArabic
            ? Border(
                left: BorderSide(
                  color: isDark ? Colors.grey[600]! : AppColor.blackColor,
                  width: 3,
                ),
              )
            : Border(
                right: BorderSide(
                  color: isDark ? Colors.grey[600]! : AppColor.blackColor,
                  width: 3,
                ),
              ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Saudi emblem

          Image.asset(
            'assets/images/saudi_logo.png',
            height: 25,
            width: 25,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDark ? Colors.grey[600]! : AppColor.blackColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 20,
                color: isDark ? Colors.grey[400] : AppColor.grey,
              ),
            ),
          ),

          const SizedBox(height: 2),

          // Arabic text for Saudi Arabia

          Text(
            'السعودية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 9,
              color: isDark ? Colors.grey[300] : AppColor.blackColor,
            ),
          ),

          const SizedBox(height: 2),

          // KSA text

          Column(
            children: [
              Text('K',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[300] : AppColor.blackColor,
                      fontSize: 18)),
              Text('S',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[300] : AppColor.blackColor,
                      fontSize: 18)),
              Text('A',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[300] : AppColor.blackColor,
                      fontSize: 18)),
              SizedBox(height: 4),
              CircleAvatar(
                  radius: 6,
                  backgroundColor:
                      isDark ? Colors.grey[400] : AppColor.blackColor),
            ],
          ),
        ],
      ),
    );
  }
}
