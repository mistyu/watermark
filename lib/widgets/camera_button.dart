import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final ImageProvider image;
  final VoidCallback? onTap;
  final double? width;
  final bool borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.image,
    this.width,
    this.onTap,
    this.borderRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius ? BorderRadius.circular(8.0) : null,
            ),
            child: SizedBox(
              width: width ?? null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: image,
                    width: 24.0,
                    height: 24.0,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )));
  }
}
