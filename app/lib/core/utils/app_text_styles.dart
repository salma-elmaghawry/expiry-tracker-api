import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expiry_tracker/core/theme/app_colors.dart';

class AppTextStyles {
  static TextStyle _style(double fontSize, FontWeight fontWeight) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: fontWeight,
    ).copyWith(
      fontFamilyFallback: [
        GoogleFonts.ibmPlexSansArabic(fontWeight: fontWeight).fontFamily!,
      ],
    );
  }

  static TextStyle get font32ExtraBold => _style(32.sp, FontWeight.w800);

  static TextStyle get font24ExtraBold => _style(24.sp, FontWeight.w800);

  static TextStyle get font22ExtraBold => _style(22.sp, FontWeight.w800);

  static TextStyle get font20ExtraBold => _style(20.sp, FontWeight.w800);

  static TextStyle get font18ExtraBold => _style(18.sp, FontWeight.w800);

  static TextStyle get font17ExtraBold => _style(17.sp, FontWeight.w800);

  static TextStyle get font16ExtraBold => _style(16.sp, FontWeight.w800);

  static TextStyle get font15ExtraBold => _style(15.sp, FontWeight.w800);

  static TextStyle get font15Medium => _style(15.sp, FontWeight.w500);

  static TextStyle get font14ExtraBold => _style(14.sp, FontWeight.w800);

  static TextStyle get font13Medium => _style(13.sp, FontWeight.w500);

  static TextStyle get font13SemiBold => _style(13.sp, FontWeight.w600);

  static TextStyle get font13Bold => _style(13.sp, FontWeight.w700);

  static TextStyle get font13ExtraBold => _style(13.sp, FontWeight.w800);

  static TextStyle get font12Normal => _style(12.sp, FontWeight.normal);

  static TextStyle get font12Bold => _style(12.sp, FontWeight.w700);

  static TextStyle get font12ExtraBold => _style(12.sp, FontWeight.w800);

  static TextStyle get font32Bold => _style(32.sp, FontWeight.bold);

  static TextStyle get font24Bold => _style(24.sp, FontWeight.bold);

  static TextStyle get font20SemiBold => _style(20.sp, FontWeight.w600);

  static TextStyle get font20Bold => _style(20.sp, FontWeight.bold);

  static TextStyle get font18Normal => _style(18.sp, FontWeight.normal);

  static TextStyle get font16Normal => _style(16.sp, FontWeight.normal);

  static TextStyle get font16Medium => _style(16.sp, FontWeight.w500);

  static TextStyle get font16SemiBold => _style(16.sp, FontWeight.w600);

  static TextStyle get font16Bold => _style(16.sp, FontWeight.bold);

  static TextStyle get font14Normal => _style(14.sp, FontWeight.normal);

  static TextStyle get font14Medium => _style(14.sp, FontWeight.w500);

  static TextStyle get font14SemiBold => _style(14.sp, FontWeight.w600);

  static TextStyle get font12Medium => _style(12.sp, FontWeight.w500);

  static TextStyle get font12SemiBold => _style(12.sp, FontWeight.w600);

  static TextStyle get font10Normal => _style(10.sp, FontWeight.normal);

  static TextStyle get font10Medium => _style(10.sp, FontWeight.w500);

  static TextStyle get font10Bold => _style(10.sp, FontWeight.w700);

  static TextStyle semiBoldOf(double fontSize) =>
      _style(fontSize, FontWeight.w600);
}

extension AppTextStyleColors on TextStyle {
  TextStyle tabular() =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  TextStyle secondary(BuildContext context) => copyWith(
    color: Theme.of(context).brightness == Brightness.dark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight,
  );
}
