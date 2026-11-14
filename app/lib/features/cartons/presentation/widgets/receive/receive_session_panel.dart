import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bottom panel while the camera scans: what this session received, and Done.
class ReceiveSessionPanel extends StatelessWidget {
  final int cartonsReceived;
  final int piecesReceived;
  final VoidCallback onDone;

  const ReceiveSessionPanel({
    super.key,
    required this.cartonsReceived,
    required this.piecesReceived,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 22.r,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'receive.cartons'.plural(cartonsReceived),
                    style: AppTextStyles.font15ExtraBold,
                  ),
                  Text(
                    '${'receive.pieces'.plural(piecesReceived)} '
                    '${'receive.this_session'.tr()}',
                    style: AppTextStyles.font13Medium
                        .secondary(context)
                        .tabular(),
                  ),
                ],
              ),
            ),
            horizontalSpace(8),
            FilledButton(
              onPressed: onDone,
              style: FilledButton.styleFrom(
                minimumSize: Size(0, 44.h),
                padding: EdgeInsets.symmetric(horizontal: 18.w),
              ),
              child: Text('receive.done'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
