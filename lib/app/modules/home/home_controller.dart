import 'package:get/get.dart';

import '../../data/models/subject_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/practice_quiz_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final SubjectRepository _subjectRepo = Get.find<SubjectRepository>();
  final PracticeQuizRepository _analyticsRepo =
      Get.find<PracticeQuizRepository>();

  final currentUser = Rxn<UserModel>();
  final subjects = <SubjectModel>[].obs;
  final isLoading = false.obs;

  final totalQuizzes = 0.obs;
  final averageScore = 0.0.obs;
  final streakDays = 0.obs;

  // ✅ حقول جديدة للـ streak
  final streakStatus = 'inactive'.obs; // active / warning / frozen / inactive
  final streakDaysLeft = Rxn<int>(); // كم يوم باقي من فترة السماح

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      currentUser.value = _storageService.user;

      final subjectsList = await _subjectRepo.getSubjectsWithStats();
      subjects.value = subjectsList;

      final analytics = await _analyticsRepo.getAnalytics();

      totalQuizzes.value = (analytics['totalQuizzes'] as num?)?.toInt() ?? 0;

      averageScore.value =
          (analytics['averageScore'] as num?)?.toDouble() ??
          (subjects.isNotEmpty && totalQuizzes.value > 0
              ? subjects.fold(
                      0.0,
                      (sum, s) => sum + s.averageScore * s.totalQuizzes,
                    ) /
                    totalQuizzes.value
              : 0.0);

      // ✅ streak الجديد
      streakDays.value = (analytics['streakDays'] as num?)?.toInt() ?? 0;
      streakStatus.value = (analytics['streakStatus'] as String?) ?? 'inactive';
      streakDaysLeft.value = (analytics['streakDaysLeft'] as num?)?.toInt();
    } catch (e) {
      subjects.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ هل يظهر بانر التحذير؟
  bool get showStreakWarning => streakStatus.value == 'warning';

  // ✅ هل انتهى الـ streak؟
  bool get isStreakFrozen => streakStatus.value == 'frozen';

  void goToSubjectDetails(SubjectModel subject) =>
      Get.toNamed(AppRoutes.SUBJECT_DETAILS, arguments: subject);

  void goToProfile() => Get.toNamed(AppRoutes.PROFILE);

  Future<void> refreshData() async => await _loadData();
}
