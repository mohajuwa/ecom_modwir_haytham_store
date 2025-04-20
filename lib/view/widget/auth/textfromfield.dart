import 'package:ecom_modwir/core/constant/color_manger.dart';
import 'package:flutter/material.dart';

class MyTextFromField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType textInputType;
  final String? lapletext;
  final Color? color;
  final Widget? suifxicon;
  final Function? ontapsuffixicon;
  final Function? validate;
  final bool? obscuretext;
  final String? hinttext;
  final IconData? prefixIconData;
  final Color? prefixIconColor;
  final VoidCallback? onPrefixIconTap;

  const MyTextFromField({
    Key? key,
    required this.controller,
    required this.textInputType,
    this.lapletext,
    this.color,
    this.suifxicon,
    this.ontapsuffixicon,
    this.validate,
    this.obscuretext,
    this.hinttext,
    this.prefixIconData,
    this.prefixIconColor,
    this.onPrefixIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      validator: (value) {
        return validate != null ? validate!(value) : null;
      },
      obscureText: obscuretext ?? false,
      decoration: InputDecoration(
        prefixIcon: prefixIconData != null
            ? IconButton(
                icon: Icon(
                  prefixIconData,
                  color: prefixIconColor,
                ),
                onPressed: onPrefixIconTap,
              )
            : null,
        filled: true,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        suffixIconColor: ColorApp.lightblue,
        suffixIcon: suifxicon != null
            ? IconButton(
                onPressed: () {
                  ontapsuffixicon!();
                },
                icon: suifxicon!,
              )
            : null,
        fillColor: color,
        labelText: lapletext,
        hintText: hinttext,
      ),
    );
  }
}

// Keep your existing validation functions
vildate(value, name) {
  if (value.isEmpty) {
    return '$name Must Not Empty';
  }
}

vildateemail(value) {
  if (value.isEmpty) {
    return 'Email Must Not Empty';
  }
  String pattern = r'\w+@\w+\.\w+';
  if (!RegExp(pattern).hasMatch(value)) {
    return 'Invalid E-mail Address format.';
  }
  return null;
}
