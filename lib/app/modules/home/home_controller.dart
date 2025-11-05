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

  void goToProfile() {
    Get.toNamed(AppRoutes.PROFILE);
  }

  Future<void> refreshData() async {
    await _loadData();
  }
}
