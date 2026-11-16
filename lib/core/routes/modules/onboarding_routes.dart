import 'package:get/get.dart';
import 'package:kalori/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:kalori/features/onboarding/presentation/screens/onboarding_screen.dart';

class OnboardingRoutes {
  static List<GetPage<dynamic>> routes = [
    GetPage(
      name: OnboardingView.path,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
  ];
}
