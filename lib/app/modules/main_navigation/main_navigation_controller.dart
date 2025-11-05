import 'package:get/get.dart';
import '../home/home_view.dart';
import '../quiz_setup/quiz_setup_view.dart';
import '../summaries/summaries_view.dart';
import '../analytics/analytics_view.dart';
import '../profile/profile_view.dart';

class MainNavigationController extends GetxController {
  final selectedIndex = 2.obs;
  final screens = [
    const SummariesView(),
    const QuizSetupView(),
    const HomeView(),

    const AnalyticsView(),
    const ProfileView(),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
