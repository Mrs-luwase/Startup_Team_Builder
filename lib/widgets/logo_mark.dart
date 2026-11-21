import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Logo n brand
class LogoMark extends StatelessWidget {
  final double size;
  const LogoMark({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Text(
        'S',
        style: TextStyle(
          fontSize: size * 0.5,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
    );
  }
}