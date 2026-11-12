import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget centeredCupertinoLoader({Color? color, double size = 30}) {
  return Center(
    child: SizedBox(
      width: size,
      height: size,
      child: CupertinoActivityIndicator(
        color: color ?? AppColors.primary,
        radius: size / 2,
      ),
    ),
  );
}

void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  double bottomOffset = 0,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final iconColor = isError
      ? (Theme.of(context).brightness == Brightness.dark
            ? AppColors.error
            : AppColors.errorDark)
      : colorScheme.inversePrimary;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        margin: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16 + bottomOffset),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_rounded,
              color: iconColor,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.font14SemiBold.copyWith(
                  color: colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
