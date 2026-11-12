import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('not_found.title'.tr())),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64.r,
                color: Theme.of(context).colorScheme.primary,
              ),
              verticalSpace(16),
              Text(
                'not_found.message'.tr(),
                style: AppTextStyles.font16Normal,
                textAlign: TextAlign.center,
              ),
              verticalSpace(24),
              ElevatedButton(
                onPressed: () => context.go(Routes.dashboard),
                child: Text('not_found.go_home'.tr()),
              ),
            ],
          ).fadeInSlideUp(),
        ),
      ),
    );
  }
}
