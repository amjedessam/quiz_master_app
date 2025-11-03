// import 'package:get/get.dart';
// import '../../data/models/user_model.dart';
// import '../../data/models/subject_model.dart';
// import '../../data/services/storage_service.dart';
// import '../../data/services/mock_data_service.dart';
// import '../../routes/app_routes.dart';

// class HomeController extends GetxController {
//   final StorageService _storageService = Get.find<StorageService>();

//   final currentUser = Rxn<UserModel>();
//   final subjects = <SubjectModel>[].obs;
//   final isLoading = false.obs;
//   final selectedNavIndex = 0.obs;

//   final totalQuizzes = 0.obs;
//   final averageScore = 0.0.obs;
//   final streakDays = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     isLoading.value = true;

//     await Future.delayed(const Duration(milliseconds: 500));

//     currentUser.value = _storageService.user;
//     subjects.value = MockDataService.getMockSubjects();

//     // Calculate statistics
//     totalQuizzes.value = subjects.fold(
//       0,
//       (sum, subject) => sum + subject.totalQuizzes,
//     );

//     final totalScore = subjects.fold(
//       0.0,
//       (sum, subject) => sum + (subject.averageScore * subject.totalQuizzes),
//     );
//     averageScore.value = totalQuizzes.value > 0
//         ? (totalScore / totalQuizzes.value)
//         : 0.0;

//     streakDays.value = 7; // Mock data

//     isLoading.value = false;
//   }

//   void goToSubjectDetails(SubjectModel subject) {
//     Get.toNamed(AppRoutes.SUBJECT_DETAILS, arguments: subject);
//   }

//   void goToAnalytics() {
//     Get.toNamed(AppRoutes.ANALYTICS);
//   }

//   void goToHistory() {
//     Get.toNamed(AppRoutes.HISTORY);
//   }

//   void goToProfile() {
//     Get.toNamed(AppRoutes.PROFILE);
//   }

//   void changeNavIndex(int index) {
//     selectedNavIndex.value = index;

//     switch (index) {
//       case 0:
//         // Home - already here
//         break;
//       case 1:
//         goToAnalytics();
//         break;
//       case 2:
//         goToHistory();
//         break;
//       case 3:
//         goToProfile();
//         break;
//     }
//   }

//   Future<void> refreshData() async {
//     await _loadData();
//   }
// }

import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/subject_model.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/mock_data_service.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final currentUser = Rxn<UserModel>();
  final subjects = <SubjectModel>[].obs;
  final isLoading = false.obs;
  final selectedNavIndex = 0.obs;

  final totalQuizzes = 0.obs;
  final averageScore = 0.0.obs;
  final streakDays = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    // جلب بيانات المستخدم الحقيقية
    currentUser.value = _storageService.user;
    subjects.value = MockDataService.getMockSubjects();

    totalQuizzes.value = subjects.fold(
      0,
      (sum, subject) => sum + subject.totalQuizzes,
    );

    final totalScore = subjects.fold(
      0.0,
      (sum, subject) => sum + (subject.averageScore * subject.totalQuizzes),
    );
    averageScore.value = totalQuizzes.value > 0
        ? (totalScore / totalQuizzes.value)
        : 0.0;

    streakDays.value = 7;

    isLoading.value = false;
  }

  void goToSubjectDetails(SubjectModel subject) {
    Get.toNamed(AppRoutes.SUBJECT_DETAILS, arguments: subject);
  }

  void goToQuizSetup() {
    Get.toNamed(AppRoutes.QUIZ_SETUP);
  }

  void goToSummaries() {
    Get.toNamed(AppRoutes.SUMMARIES);
  }

  void goToAnalytics() {
    Get.toNamed(AppRoutes.ANALYTICS);
  }

  void goToProfile() {
    Get.toNamed(AppRoutes.PROFILE);
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;

    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        goToQuizSetup();
        break;
      case 2:
        goToSummaries();
        break;
      case 3:
        goToAnalytics();
        break;
    }
  }

  Future<void> refreshData() async {
    await _loadData();
  }
}
