import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/widgets/coming_next_view.dart';
import 'package:flutter/material.dart';

class AddBatchScreen extends StatelessWidget {
  const AddBatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('batches.add'.tr())),
      body: const ComingNextView(icon: Icons.qr_code_scanner_rounded),
    );
  }
}
