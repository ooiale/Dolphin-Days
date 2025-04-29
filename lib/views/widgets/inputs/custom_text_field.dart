import 'package:flutter/material.dart';
import 'package:dolphin_days/data/themes/text_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTextFonts.boldGrayLabelStyle,
        border: OutlineInputBorder(),
      ),
      style: AppTextFonts.boldWhiteTextStyle,
      maxLines: maxLines,
    );
  }
}