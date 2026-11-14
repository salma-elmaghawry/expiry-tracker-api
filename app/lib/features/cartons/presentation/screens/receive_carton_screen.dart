import 'package:expiry_tracker/core/injection/injection_container.dart';
import 'package:expiry_tracker/features/cartons/presentation/cubit/receive_carton_cubit.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/receive/receive_carton_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Receiving session: scan a carton QR, check it, save it, scan the next one.
/// Lives outside the shell, so the camera covers the whole screen.
class ReceiveCartonScreen extends StatelessWidget {
  const ReceiveCartonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReceiveCartonCubit>(),
      child: const ReceiveCartonView(),
    );
  }
}
