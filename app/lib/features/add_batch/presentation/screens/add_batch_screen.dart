import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddBatchScreen extends StatefulWidget {
  const AddBatchScreen({super.key});

  @override
  State<AddBatchScreen> createState() => _AddBatchScreenState();
}

class _AddBatchScreenState extends State<AddBatchScreen> {
  final _barcodeController = TextEditingController();
  final _barcodeFocus = FocusNode();

  @override
  void dispose() {
    _barcodeController.dispose();
    _barcodeFocus.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    // Same idea as `await Navigator.push(...)`: wait here until the scanner
    // closes, then read what it handed back with `context.pop(value)`.
    final result = await context.push<String>(Routes.scan);
    if (!mounted || result == null) return;

    if (result == ScannerScreen.enterManually) {
      _barcodeFocus.requestFocus();
      return;
    }
    _barcodeController.text = result;
  }

  void _close() {
    // Opened by a link on web (nothing to go back to): go to the list instead.
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.batches);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'common.close'.tr(),
          onPressed: _close,
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text('batches.add'.tr()),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          Text.rich(
            TextSpan(
              text: '${'add_batch.barcode'.tr()} ',
              style: AppTextStyles.font13ExtraBold,
              children: [
                TextSpan(
                  text: 'add_batch.optional'.tr(),
                  style: AppTextStyles.font13SemiBold.secondary(context),
                ),
              ],
            ),
          ),
          verticalSpace(6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _barcodeController,
                  focusNode: _barcodeFocus,
                  // On web a USB scanner "types" the code, so the field is ready for it.
                  autofocus: kIsWeb,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  style: AppTextStyles.font16SemiBold.tabular(),
                  decoration: InputDecoration(
                    hintText: 'add_batch.barcode_hint'.tr(),
                  ),
                ),
              ),
              // The camera scanner is for phones. On web, staff use a USB scanner.
              if (!kIsWeb) ...[
                horizontalSpace(8),
                IconButton(
                  tooltip: 'add_batch.scan'.tr(),
                  onPressed: _scan,
                  style: IconButton.styleFrom(
                    fixedSize: Size.square(52.r),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  icon: Icon(Icons.qr_code_scanner_rounded, size: 24.r),
                ),
              ],
            ],
          ),
          verticalSpace(16),
          Text(
            'add_batch.more_fields'.tr(),
            style: AppTextStyles.font13Medium.secondary(context),
          ),
        ],
      ),
    );
  }
}
