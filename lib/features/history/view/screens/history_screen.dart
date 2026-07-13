import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      appBar: AppBar(
        title: Text('History', style: context.typography.headlineMd),
        backgroundColor: KaloriColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Text('History Page', style: context.typography.headlineLgMobile),
      ),
    );
  }
}
