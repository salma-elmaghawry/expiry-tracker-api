import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppAnimations.splashHold, () {
      if (mounted) context.go(Routes.dashboard);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 88).popIn(),
            verticalSpace(16),
            Text(
              'app_name'.tr(),
              style: AppTextStyles.font24Bold,
            ).fadeInSlideUp(delay: AppAnimations.sectionDelay),
            verticalSpace(8),
            Text(
              'app_tagline'.tr(),
              style: AppTextStyles.font14Normal.secondary(context),
            ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 2),
          ],
        ),
      ),
    );
  }
}
