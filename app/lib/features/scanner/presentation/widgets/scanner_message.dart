import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Shown instead of the camera when it can't start: either the staff member
/// tapped "Don't allow" on the camera popup, or another app is using it.
class ScannerMessage extends StatelessWidget {
  final MobileScannerException error;
  final VoidCallback onRetry;

  const ScannerMessage({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;

    return ColoredBox(
      color: AppColors.scannerBackground,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  denied
                      ? Icons.no_photography_outlined
                      : Icons.videocam_off_outlined,
                  size: 36.r,
                  color: Colors.white,
                ),
              ),
              verticalSpace(20),
              Text(
                (denied ? 'scanner.denied_title' : 'scanner.error_title').tr(),
                style: AppTextStyles.font20ExtraBold.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpace(8),
              Text(
                (denied ? 'scanner.denied_body' : 'scanner.error_body').tr(),
                style: AppTextStyles.font14Normal.copyWith(
                  color: AppColors.scannerHint,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpace(24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('scanner.try_again'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
