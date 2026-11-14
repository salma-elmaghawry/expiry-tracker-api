import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/ui_helpers.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/cartons/presentation/cubit/receive_carton_cubit.dart';
import 'package:expiry_tracker/features/cartons/presentation/cubit/receive_carton_state.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/receive/receive_header.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/receive/receive_session_panel.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/receive/receive_sheet.dart';
import 'package:expiry_tracker/features/scanner/presentation/widgets/scan_line.dart';
import 'package:expiry_tracker/features/scanner/presentation/widgets/scanner_message.dart';
import 'package:expiry_tracker/features/scanner/presentation/widgets/scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ReceiveCartonView extends StatefulWidget {
  const ReceiveCartonView({super.key});

  @override
  State<ReceiveCartonView> createState() => _ReceiveCartonViewState();
}

class _ReceiveCartonViewState extends State<ReceiveCartonView> {
  final MobileScannerController _camera = MobileScannerController(
    // After "Save and scan next" the camera still sees the carton we just
    // saved. noDuplicates stops it from reading that same QR again.
    detectionSpeed: DetectionSpeed.noDuplicates,
    // Cartons also carry product barcodes. Reading QR codes only means the
    // camera can never pick one of those by mistake.
    formats: const [BarcodeFormat.qrCode],
  );

  // Built once, so cubit rebuilds never recreate the camera view.
  late final Widget _cameraView = MobileScanner(
    controller: _camera,
    onDetect: _onDetect,
    errorBuilder: (context, error) =>
        ScannerMessage(error: error, onRetry: _startCamera),
  );

  ReceiveCartonCubit get _cubit => context.read<ReceiveCartonCubit>();

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_cubit.state.isScanning) return;

    final code = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .firstWhere(
          (value) => value != null && value.isNotEmpty,
          orElse: () => null,
        );
    if (code == null) return;

    HapticFeedback.mediumImpact();
    // pause() freezes the last frame (the design's "Camera paused")
    // without releasing the camera, so start() resumes instantly.
    _camera.pause();
    _cubit.check(code);
  }

  Future<void> _startCamera() async {
    try {
      await _camera.start();
    } on MobileScannerException {
      // The controller keeps the error, and ScannerMessage shows it.
    }
  }

  void _scanNext() {
    _cubit.scanNext();
    _startCamera();
  }

  void _finish() {
    final state = _cubit.state;
    if (state.cartonsReceived > 0) {
      // Shown by the app's ScaffoldMessenger, so it stays on the next screen.
      showAppSnackBar(
        context,
        '${'receive.cartons'.plural(state.cartonsReceived)} · '
        '${'receive.pieces'.plural(state.piecesReceived)}',
      );
    }

    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.batches);
    }
  }

  void _onStateChanged(BuildContext context, ReceiveCartonState state) {
    if (state.justSaved) {
      final carton = state.lastSaved!;
      if (state.scanNextAfterSave) {
        showAppSnackBar(
          context,
          'receive.saved'.tr(
            args: [
              carton.productName,
              'receive.pieces'.plural(carton.totalPieces),
            ],
          ),
        );
        _scanNext();
      } else {
        _finish();
      }
      return;
    }

    if (state.saveFailed) {
      final failure = state.failure;
      final needsPrice =
          failure is ValidationFailure &&
          failure.fieldErrors.containsKey('sellingPricePiasters');
      showAppSnackBar(
        context,
        needsPrice ? 'receive.price_required'.tr() : state.message ?? '',
        isError: true,
      );
    }
  }

  // Design: 250 x 250 frame on a 360 x 800 screen, centred at y = 345.
  Rect _frameFor(Size size) {
    final side = size.width * 250 / 360;
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 345 / 800),
      width: side,
      height: side,
    );
  }

  Color _frameColor(ReceiveCartonState state) {
    if (state.checkFailed) return AppColors.scannerError;
    final preview = state.preview;
    if (preview == null) return Colors.white;
    return preview.isDuplicate ? AppColors.secondary : AppColors.primaryDark;
  }

  String _title(ReceiveCartonState state) {
    if (state.isScanning) return 'receive.title'.tr();
    final isNewProduct =
        state.preview != null &&
        !state.preview!.isDuplicate &&
        state.preview!.needsSellingPrice;
    return (isNewProduct ? 'receive.title_new' : 'receive.title_scanned').tr();
  }

  @override
  Widget build(BuildContext context) {
    // Light status bar icons, because this screen is always dark.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocConsumer<ReceiveCartonCubit, ReceiveCartonState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.action != current.action,
        listener: _onStateChanged,
        builder: (context, state) {
          return PopScope(
            // Back never leaves directly: with the sheet open it returns to
            // the camera, and while scanning it ends the session (snackbar).
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              state.isScanning ? _finish() : _scanNext();
            },
            child: Scaffold(
              backgroundColor: AppColors.scannerBackground,
              // The sheet lifts itself above the keyboard; the camera stays put.
              resizeToAvoidBottomInset: false,
              body: ValueListenableBuilder<MobileScannerState>(
                valueListenable: _camera,
                builder: (context, camera, _) {
                  final cameraFailed = camera.error != null;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final frame = _frameFor(constraints.biggest);

                      return Stack(
                        children: [
                          Positioned.fill(child: _cameraView),
                          if (!cameraFailed) ...[
                            ScannerOverlay(
                              frame: frame,
                              cornerColor: _frameColor(state),
                              radius: 20,
                              cornerLength: 44,
                              cornerStroke: 5,
                            ),
                            if (state.isScanning) ...[
                              ScanLine(frame: frame, inset: 18),
                              _hints(),
                            ],
                          ],
                          ReceiveHeader(
                            title: _title(state),
                            isScanning: state.isScanning,
                            torchState: cameraFailed
                                ? TorchState.unavailable
                                : camera.torchState,
                            onToggleTorch: _camera.toggleTorch,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: state.isScanning
                                ? ReceiveSessionPanel(
                                    cartonsReceived: state.cartonsReceived,
                                    piecesReceived: state.piecesReceived,
                                    onDone: _finish,
                                  )
                                : ReceiveSheet(
                                    state: state,
                                    onScanNext: _scanNext,
                                    onRetry: _cubit.retryCheck,
                                    onSave: (price, scanNext) => _cubit.save(
                                      sellingPricePiasters: price,
                                      scanNext: scanNext,
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hints() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 64.h + 40.h, 24.w, 0),
          child: Column(
            children: [
              Text(
                'receive.hint'.tr(),
                style: AppTextStyles.font16ExtraBold.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpace(6),
              Text(
                'receive.hint_sub'.tr(),
                style: AppTextStyles.font13Medium.copyWith(
                  color: AppColors.scannerHint,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
