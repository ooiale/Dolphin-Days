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
        labelStyle: AppTextFonts.boldGrayLabelStyle,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: labelText,
        filled: true,
        fillColor: Colors.white.withAlpha(100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: AppTextFonts.boldBlackTextStyle.copyWith(
        fontSize: 22,
        color: const Color(0xFF4B0082),
      ),
      maxLines: maxLines,
    );
  }
}
