import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatchesHeader extends StatelessWidget {
  final int total;
  final bool searching;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleSearch;

  const BatchesHeader({
    super.key,
    required this.total,
    required this.searching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onToggleSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 8.w, 4.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 52.h),
        child: Row(
          children: [
            Expanded(
              child: searching
                  ? TextField(
                      controller: searchController,
                      autofocus: true,
                      onChanged: onSearchChanged,
                      style: AppTextStyles.font16Medium,
                      decoration: InputDecoration(
                        hintText: 'batches.search_hint'.tr(),
                        prefixIcon: const Icon(Icons.search_rounded),
                        isDense: true,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'nav.batches'.tr(),
                          style: AppTextStyles.font22ExtraBold,
                        ),
                        Text(
                          'batches.subtitle'.tr(args: ['$total']),
                          style: AppTextStyles.font13SemiBold.secondary(
                            context,
                          ),
                        ),
                      ],
                    ),
            ),
            IconButton(
              tooltip: searching ? 'common.close'.tr() : 'batches.search'.tr(),
              iconSize: 22.r,
              onPressed: onToggleSearch,
              icon: Icon(
                searching ? Icons.close_rounded : Icons.search_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
