import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/widgets/coming_next_view.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav.reports'.tr())),
      body: const ComingNextView(icon: Icons.bar_chart_outlined),
    );
  }
}
