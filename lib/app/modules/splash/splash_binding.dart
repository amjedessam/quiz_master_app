import 'package:get/get.dart';
import '../../data/repositories/practice_quiz_repository.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/supabase_service.dart';
import 'splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SupabaseService>(SupabaseService(), permanent: true);
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<SubjectRepository>(SubjectRepository(), permanent: true);
    Get.put<QuestionRepository>(QuestionRepository(), permanent: true);
    Get.put<PracticeQuizRepository>(PracticeQuizRepository(), permanent: true);
    Get.put<SplashController>(SplashController());
  }
}
