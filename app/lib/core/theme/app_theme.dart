import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get light => _build(
    const _Palette(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      tertiary: AppColors.third,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outlineLight,
      disabledText: AppColors.disabledTextLight,
      snackBackground: AppColors.snackBackgroundLight,
      snackForeground: AppColors.textPrimaryDark,
      snackAccent: AppColors.snackAccentLight,
      scrim: Color(0x7A0A1410),
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      surfaceMuted: AppColors.surfaceMutedLight,
      border: AppColors.borderLight,
      textPrimary: AppColors.textPrimaryLight,
      textSecondary: AppColors.textSecondaryLight,
      primaryContainer: AppColors.primaryContainerLight,
      onPrimaryContainer: AppColors.onPrimaryContainerLight,
      statusColors: StatusColors.light,
    ),
  );

  static ThemeData get dark => _build(
    const _Palette(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.onPrimaryDark,
      tertiary: AppColors.thirdDark,
      error: AppColors.errorDark,
      onError: AppColors.onErrorDark,
      outline: AppColors.outlineDark,
      disabledText: AppColors.disabledTextDark,
      snackBackground: AppColors.snackBackgroundDark,
      snackForeground: AppColors.textPrimaryLight,
      snackAccent: AppColors.snackAccentDark,
      scrim: Color(0x9E000000),
      background: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
      surfaceMuted: AppColors.surfaceMutedDark,
      border: AppColors.borderDark,
      textPrimary: AppColors.textPrimaryDark,
      textSecondary: AppColors.textSecondaryDark,
      primaryContainer: AppColors.primaryContainerDark,
      onPrimaryContainer: AppColors.onPrimaryContainerDark,
      statusColors: StatusColors.dark,
    ),
  );

  static ThemeData _build(_Palette palette) {
    final isDark = palette.brightness == Brightness.dark;
    final controlRadius = BorderRadius.circular(12.r);
    final cardRadius = BorderRadius.circular(16.r);

    final pillShape = const StadiumBorder();

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: palette.brightness,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primaryContainer,
      onPrimaryContainer: palette.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimaryLight,
      tertiary: palette.tertiary,
      error: palette.error,
      onError: palette.onError,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      onSurfaceVariant: palette.textSecondary,
      surfaceContainerLowest: palette.background,
      surfaceContainerLow: palette.surfaceMuted,
      surfaceContainer: palette.surfaceMuted,
      surfaceContainerHigh: palette.surfaceMuted,
      outline: palette.outline,
      outlineVariant: palette.border,
      surfaceContainerHighest: palette.surfaceMuted,
      inverseSurface: palette.snackBackground,
      onInverseSurface: palette.snackForeground,
      inversePrimary: palette.snackAccent,
      scrim: palette.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      colorScheme: colorScheme,
      primaryColor: palette.primary,
      scaffoldBackgroundColor: palette.background,
      dividerColor: palette.border,
      extensions: [palette.statusColors],
      textTheme: TextTheme(
        displayLarge: AppTextStyles.font32Bold.copyWith(
          color: palette.textPrimary,
        ),
        displayMedium: AppTextStyles.font24Bold.copyWith(
          color: palette.textPrimary,
        ),
        displaySmall: AppTextStyles.font20Bold.copyWith(
          color: palette.textPrimary,
        ),
        bodyLarge: AppTextStyles.font18Normal.copyWith(
          color: palette.textPrimary,
        ),
        bodyMedium: AppTextStyles.font16Normal.copyWith(
          color: palette.textPrimary,
        ),
        bodySmall: AppTextStyles.font14Normal.copyWith(
          color: palette.textSecondary,
        ),
        labelLarge: AppTextStyles.font14Medium.copyWith(
          color: palette.textPrimary,
        ),
        labelMedium: AppTextStyles.font12Medium.copyWith(
          color: palette.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.font20Bold.copyWith(
          color: palette.textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: cardRadius,
          side: BorderSide(color: palette.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 80.h,
        indicatorColor: palette.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => AppTextStyles.font12ExtraBold.copyWith(
            color: states.contains(WidgetState.selected)
                ? palette.onPrimaryContainer
                : palette.textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24.r,
            color: states.contains(WidgetState.selected)
                ? palette.onPrimaryContainer
                : palette.textSecondary,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor: palette.border,
          disabledForegroundColor: palette.disabledText,
          minimumSize: Size(0, 52.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          textStyle: AppTextStyles.font16ExtraBold,
          shape: pillShape,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          elevation: 0,
          minimumSize: Size(0, 52.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          textStyle: AppTextStyles.font16ExtraBold,
          shape: pillShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          minimumSize: Size(0, 52.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          textStyle: AppTextStyles.font16ExtraBold,
          side: BorderSide(color: palette.outline),
          shape: pillShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          minimumSize: Size(0, 48.h),
          textStyle: AppTextStyles.font15ExtraBold,
          shape: pillShape,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: palette.surface,
          foregroundColor: palette.textPrimary,
          selectedBackgroundColor: palette.primaryContainer,
          selectedForegroundColor: palette.onPrimaryContainer,
          side: BorderSide(color: palette.border),
          textStyle: AppTextStyles.font14Medium,
          shape: RoundedRectangleBorder(borderRadius: controlRadius),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: palette.primaryContainer,
        checkmarkColor: palette.onPrimaryContainer,
        labelStyle: AppTextStyles.font14ExtraBold.copyWith(
          color: palette.textPrimary,
        ),
        secondaryLabelStyle: AppTextStyles.font14ExtraBold.copyWith(
          color: palette.onPrimaryContainer,
        ),
        side: BorderSide(color: palette.outline),
        shape: pillShape,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        hintStyle: AppTextStyles.font14Normal.copyWith(
          color: palette.textSecondary,
        ),
        labelStyle: AppTextStyles.font14Medium.copyWith(
          color: palette.textSecondary,
        ),
        border: _outline(controlRadius, palette.outline),
        enabledBorder: _outline(controlRadius, palette.outline),
        focusedBorder: _outline(controlRadius, palette.primary, width: 2),
        errorBorder: _outline(controlRadius, palette.error),
        focusedErrorBorder: _outline(controlRadius, palette.error, width: 2),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        elevation: isDark ? 0 : 3,
        highlightElevation: isDark ? 0 : 6,
        extendedTextStyle: AppTextStyles.font16ExtraBold,
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textSecondary,
        titleTextStyle: AppTextStyles.font16Medium.copyWith(
          color: palette.textPrimary,
        ),
        subtitleTextStyle: AppTextStyles.font14Normal.copyWith(
          color: palette.textSecondary,
        ),
        shape: RoundedRectangleBorder(borderRadius: controlRadius),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: palette.outline,
        dragHandleSize: Size(32.w, 4.h),
        modalBarrierColor: palette.scrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        titleTextStyle: AppTextStyles.font20Bold.copyWith(
          color: palette.textPrimary,
        ),
        contentTextStyle: AppTextStyles.font14Normal.copyWith(
          color: palette.textSecondary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.snackBackground,
        contentTextStyle: AppTextStyles.font14SemiBold.copyWith(
          color: palette.snackForeground,
        ),
        actionTextColor: palette.snackAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.textPrimary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        textStyle: AppTextStyles.font12Medium.copyWith(color: palette.surface),
      ),
    );
  }

  static OutlineInputBorder _outline(
    BorderRadius radius,
    Color color, {
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _Palette {
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color tertiary;
  final Color error;
  final Color onError;
  final Color outline;
  final Color disabledText;
  final Color snackBackground;
  final Color snackForeground;
  final Color snackAccent;
  final Color scrim;
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final StatusColors statusColors;

  const _Palette({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.tertiary,
    required this.error,
    required this.onError,
    required this.outline,
    required this.disabledText,
    required this.snackBackground,
    required this.snackForeground,
    required this.snackAccent,
    required this.scrim,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.statusColors,
  });
}
