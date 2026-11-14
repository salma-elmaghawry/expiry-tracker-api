import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/scanner/presentation/widgets/scanner_message.dart';
import 'package:expiry_tracker/features/scanner/presentation/widgets/scan_line.dart';
import 'package:expiry_tracker/features/scanner/presentation/widgets/scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Full-screen camera that reads one barcode.
///
/// Open it with `await context.push<String>(Routes.scan)`. It returns:
/// - the barcode, when one is found
/// - [enterManually], when staff tap "Enter manually"
/// - null, when they go back
class ScannerScreen extends StatefulWidget {
  static const String enterManually = '';

  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // Like a TextEditingController, but for the camera: it starts and stops it,
  // turns the torch on and off, and holds its current state.
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _found = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_found) return;

    final code = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .firstWhere(
          (value) => value != null && value.isNotEmpty,
          orElse: () => null,
        );
    if (code == null) return;

    setState(() => _found = true);
    HapticFeedback.mediumImpact();

    // A short pause so staff see the frame turn green before it closes.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (mounted) context.pop(code);
  }

  Future<void> _retry() async {
    try {
      await _controller.start();
    } on MobileScannerException {
      // Nothing to do here: the controller keeps the error in its state,
      // and ScannerMessage shows it again.
    }
  }

  // The design is 360 x 800 with a 280 x 170 frame centred at y = 340.
  Rect _frameFor(Size size) {
    final width = size.width - 80.w;
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.425),
      width: width,
      height: width * 170 / 280,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Light status bar icons, because this screen is always dark.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.scannerBackground,
        // Rebuilds when the camera state changes (started, error, torch).
        // `child` is built once and reused, so the camera view never restarts.
        body: ValueListenableBuilder<MobileScannerState>(
          valueListenable: _controller,
          child: MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) =>
                ScannerMessage(error: error, onRetry: _retry),
          ),
          builder: (context, state, camera) {
            final hasError = state.error != null;

            return LayoutBuilder(
              builder: (context, constraints) {
                final frame = _frameFor(constraints.biggest);

                return Stack(
                  children: [
                    Positioned.fill(child: camera!),
                    if (!hasError) ...[
                      ScannerOverlay(
                        frame: frame,
                        cornerColor: _found
                            ? AppColors.primaryDark
                            : Colors.white,
                      ),
                      if (!_found) ScanLine(frame: frame),
                      _instructions(frame),
                    ],
                    _header(state, showTorch: !hasError),
                    _enterManuallyButton(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _header(MobileScannerState state, {required bool showTorch}) {
    final torchOn = state.torchState == TorchState.on;
    final torchAvailable = state.torchState != TorchState.unavailable;

    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 64.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            children: [
              const BackButton(color: Colors.white),
              horizontalSpace(4),
              Expanded(
                child: Text(
                  'scanner.title'.tr(),
                  style: AppTextStyles.font20ExtraBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              if (showTorch && torchAvailable)
                IconButton(
                  tooltip: (torchOn ? 'scanner.torch_off' : 'scanner.torch_on')
                      .tr(),
                  onPressed: _controller.toggleTorch,
                  style: IconButton.styleFrom(
                    fixedSize: Size.square(48.r),
                    backgroundColor: torchOn
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.14),
                    foregroundColor: torchOn
                        ? AppColors.scannerBackground
                        : Colors.white,
                  ),
                  icon: Icon(
                    torchOn
                        ? Icons.flashlight_on_rounded
                        : Icons.flashlight_off_rounded,
                    size: 22.r,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _instructions(Rect frame) {
    return Positioned(
      top: frame.bottom + 24.h,
      left: 24.w,
      right: 24.w,
      child: Column(
        children: [
          Text(
            'scanner.hint'.tr(),
            style: AppTextStyles.font16Bold.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          verticalSpace(6),
          Text(
            'scanner.hint_sub'.tr(),
            style: AppTextStyles.font14Normal.copyWith(
              color: AppColors.scannerHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _enterManuallyButton() {
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 0,
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: 32.h),
        child: OutlinedButton.icon(
          onPressed: () => context.pop(ScannerScreen.enterManually),
          style: OutlinedButton.styleFrom(
            minimumSize: Size.fromHeight(56.h),
            shape: const StadiumBorder(),
            side: const BorderSide(color: Colors.white70, width: 1.5),
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.font16ExtraBold,
          ),
          icon: Icon(Icons.keyboard_rounded, size: 22.r),
          label: Text('scanner.enter_manually'.tr()),
        ),
      ),
    );
  }
}
