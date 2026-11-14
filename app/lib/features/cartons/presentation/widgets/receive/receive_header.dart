import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Back, title, and either the torch (while scanning) or "Camera paused".
class ReceiveHeader extends StatelessWidget {
  final String title;
  final bool isScanning;
  final TorchState torchState;
  final VoidCallback onToggleTorch;

  const ReceiveHeader({
    super.key,
    required this.title,
    required this.isScanning,
    required this.torchState,
    required this.onToggleTorch,
  });

  @override
  Widget build(BuildContext context) {
    final torchOn = torchState == TorchState.on;
    final torchAvailable = torchState != TorchState.unavailable;

    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 64.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              // maybePop, so the screen's PopScope decides what Back means.
              const BackButton(color: Colors.white),
              horizontalSpace(4),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font20ExtraBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              if (isScanning && torchAvailable)
                IconButton(
                  tooltip: 'receive.torch'.tr(),
                  onPressed: onToggleTorch,
                  isSelected: torchOn,
                  style: IconButton.styleFrom(
                    fixedSize: Size.square(48.r),
                    backgroundColor: torchOn
                        ? AppColors.secondary
                        : Colors.white.withValues(alpha: 0.14),
                    foregroundColor: torchOn
                        ? AppColors.textPrimaryLight
                        : Colors.white,
                  ),
                  icon: Icon(
                    torchOn
                        ? Icons.flashlight_on_rounded
                        : Icons.flashlight_off_rounded,
                    size: 22.r,
                  ),
                ),
              if (!isScanning) _pausedChip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pausedChip() {
    return Container(
      height: 28.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'receive.paused'.tr(),
        style: AppTextStyles.font12ExtraBold.copyWith(color: Colors.white),
      ),
    );
  }
}
