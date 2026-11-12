import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/widgets/coming_next_view.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav.dashboard'.tr())),
      body: const ComingNextView(icon: Icons.space_dashboard_outlined),
    );
  }
}
