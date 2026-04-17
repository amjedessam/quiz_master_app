import 'package:get/get.dart';
import 'package:quiz_master_app/ai_services/screens/ai_quiz_setup/ai_quiz_setup_binding.dart';
import 'main_navigation_controller.dart';
import '../home/home_binding.dart';
import '../quiz_setup/quiz_setup_binding.dart';
import '../summaries/summaries_binding.dart';
import '../analytics/analytics_binding.dart';
import '../profile/profile_binding.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());

    HomeBinding().dependencies();
    AiQuizSetupBinding().dependencies();
    SummariesBinding().dependencies();
    AnalyticsBinding().dependencies();
    ProfileBinding().dependencies();
  }
}
