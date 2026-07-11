import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KaloriColors.background,
      appBar: AppBar(
        title: Text('Profile', style: context.typography.headlineMd),
        backgroundColor: KaloriColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Profile Settings & Goals',
          style: context.typography.bodyLg,
        ),
      ),
    );
  }
}
