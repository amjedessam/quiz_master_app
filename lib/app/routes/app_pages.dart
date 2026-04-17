import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // ✅ أضفنا هذا
import 'package:quiz_master_app/ai_services/ai_services.dart';
import 'package:quiz_master_app/ai_services/screens/ai_quiz/ai_quiz_binding.dart';
import 'package:quiz_master_app/ai_services/screens/ai_quiz_setup/ai_quiz_setup_binding.dart';
import 'package:quiz_master_app/ai_services/screens/quiz_result_screen.dart';
import 'package:quiz_master_app/app/modules/amjed/maintabview.dart';
import 'package:quiz_master_app/app/modules/assigned_exams/assigned_exams_binding.dart';
import 'package:quiz_master_app/app/modules/assigned_exams/assigned_exams_controller.dart';
import 'package:quiz_master_app/app/modules/assigned_exams/assigned_exams_view.dart';
import 'package:quiz_master_app/app/modules/onboarding/onboarding_screen.dart';
import 'package:quiz_master_app/app/modules/subject_pdf.dart/Subject_Pdf_Binding.dart';
import 'package:quiz_master_app/app/modules/subject_pdf.dart/subject_pdf_view.dart';
import '../modules/chapter_details/chapter_details_binding.dart';
import '../modules/chapter_details/chapter_details_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/register/register_binding.dart';
import '../modules/auth/register/register_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/subject_details/subject_details_binding.dart';
import '../modules/subject_details/subject_details_view.dart';
import '../modules/quiz_setup/quiz_setup_binding.dart';
import '../modules/quiz_setup/quiz_setup_view.dart';
import '../modules/quiz/quiz_binding.dart';
import '../modules/quiz/quiz_view.dart';
import '../modules/result/result_binding.dart';
import '../modules/result/result_view.dart';
import '../modules/review/review_binding.dart';
import '../modules/review/review_view.dart';
import '../modules/analytics/analytics_binding.dart';
import '../modules/analytics/analytics_view.dart';
import '../modules/history/history_binding.dart';
import '../modules/history/history_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/summaries/summaries_binding.dart';
import '../modules/summaries/summaries_view.dart';
import '../modules/create_summary/create_summary_binding.dart';
import '../modules/create_summary/create_summary_view.dart';
import '../modules/summary_detail/summary_detail_binding.dart';
import '../modules/summary_detail/summary_detail_view.dart';
import '../modules/explanation/explanation_binding.dart';
import '../modules/explanation/explanation_view.dart';
import '../modules/main_navigation/main_navigation_binding.dart';
import '../modules/main_navigation/main_navigation_view.dart';
import '../modules/notifications/notifications_binding.dart';
import '../modules/notifications/notifications_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.CHAPTER_DETAILS,
      page: () => const ChapterDetailsView(),
      binding: ChapterDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.SUBJECT_DETAILS,
      page: () => const SubjectDetailsView(),
      binding: SubjectDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.QUIZ_SETUP,
      page: () => AiQuizSetupScreen(
        curriculumManager: CurriculumManager(),
        questionGenerator: EnhancedQuestionGenerator(),
      ),
      binding: AiQuizSetupBinding(),
      transition: Transition.rightToLeft,
    ),
    

    // GetPage(
    //   name: AppRoutes.QUIZ_SETUP,
    //   page: () => const QuizSetupView(),
    //   binding: QuizSetupBinding(),
    //   transition: Transition.rightToLeft,
    // ),
    
    GetPage(
      name: AppRoutes.QUIZ,
      page: () => const QuizView(),
      binding: QuizBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.RESULT,
      page: () => const ResultView(),
      binding: ResultBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRoutes.REVIEW,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ANALYTICS,
      page: () => const AnalyticsView(),
      binding: AnalyticsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.SUMMARIES,
      page: () => const SummariesView(),
      binding: SummariesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.CREATE_SUMMARY,
      page: () => const CreateSummaryView(),
      binding: CreateSummaryBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.SUMMARY_DETAIL,
      page: () => const SummaryDetailView(),
      binding: SummaryDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.EXPLANATION,
      page: () => const ExplanationView(),
      binding: ExplanationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.MainTabView,
      page: () => const MainTabView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.MAIN_NAVIGATION,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.SUBJECT_PDF,
      page: () => const SubjectPdfView(),
      binding: SubjectPdfBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ASSIGNED_EXAMS,
      page: () => const AssignedExamsView(),
      binding: AssignedExamsBinding(),
    ),
    // ✅ أضفنا هذه الصفحات الجديدة
    // GetPage(
    //   name: AppRoutes.CURRICULUM_SELECTION,
    //   page: () =>  CurriculumSelectionView(),
    //   transition: Transition.rightToLeft,
    // ),
    // GetPage(
    //   name: AppRoutes.QUIZ_SCREEN,
    //   page: () => const QuizScreen(),
    //   transition: Transition.downToUp,
    // ),
    // GetPage(
    //   name: AppRoutes.QUIZ_RESULT_SCREEN,
    //   page: () => const QuizResultScreen(),
    //   transition: Transition.zoom,
    // ),
    // GetPage(
    //   name: AppRoutes.QUESTION_WIDGET,
    //   page: () => const QuestionWidget(),
    //   transition: Transition.fadeIn,
    // ),

  ];
}
