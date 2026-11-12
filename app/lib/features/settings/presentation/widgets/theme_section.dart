import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/controller/theme_cubit.dart';
import 'package:expiry_tracker/core/theme/controller/theme_state.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('settings.theme'.tr(), style: AppTextStyles.font16SemiBold),
        verticalSpace(8),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('settings.theme_system'.tr()),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('settings.theme_light'.tr()),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('settings.theme_dark'.tr()),
                ),
              ],
              selected: {state.themeMode},
              onSelectionChanged: (selection) =>
                  context.read<ThemeCubit>().setThemeMode(selection.first),
            );
          },
        ),
      ],
    );
  }
}
