import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Icon, title, message and buttons, centred. Used for "already received",
/// "not a carton label" and network errors inside the result sheet.
class ReceiveMessageView extends StatelessWidget {
  final IconData icon;
  final StatusTone tone;
  final String title;
  final String body;
  final String? hint;
  final Widget? card;
  final List<Widget> actions;

  const ReceiveMessageView({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.body,
    this.hint,
    this.card,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: tone.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30.r, color: tone.accent),
          ),
        ),
        verticalSpace(10),
        Text(
          title,
          style: AppTextStyles.font20ExtraBold,
          textAlign: TextAlign.center,
        ),
        verticalSpace(6),
        Text(
          body,
          style: AppTextStyles.font16ExtraBold,
          textAlign: TextAlign.center,
        ),
        if (card != null) ...[verticalSpace(10), card!],
        if (hint != null) ...[
          verticalSpace(10),
          Text(
            hint!,
            style: AppTextStyles.font13Medium.secondary(context),
            textAlign: TextAlign.center,
          ),
        ],
        verticalSpace(14),
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) verticalSpace(8),
          actions[i],
        ],
      ],
    );
  }
}
