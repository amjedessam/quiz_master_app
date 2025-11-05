import '../models/user_model.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/question_model.dart';

class MockDataService {
  static UserModel getMockUser() {
    return UserModel(
      id: '1',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      avatar:
          'https://ui-avatars.com/api/?name=Ahmed+Mohamed&background=6C63FF&color=fff',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  static List<SubjectModel> getMockSubjects() {
    return [
      SubjectModel(
        id: '1',
        name: 'الرياضيات',
        description: 'الجبر والهندسة والإحصاء',
        icon: '📐',
        color: '0xFF6C63FF',
        chaptersCount: 8,
        progress: 0.75,
        totalQuizzes: 24,
        averageScore: 85.5,
      ),
      SubjectModel(
        id: '2',
        name: 'الفيزياء',
        description: 'الميكانيكا والكهرباء والضوء',
        icon: '⚛️',
        color: '0xFF00D9FF',
        chaptersCount: 6,
        progress: 0.60,
        totalQuizzes: 18,
        averageScore: 78.0,
      ),
      SubjectModel(
        id: '3',
        name: 'الكيمياء',
        description: 'الكيمياء العضوية وغير العضوية',
        icon: '🧪',
        color: '0xFF4CAF50',
        chaptersCount: 7,
        progress: 0.50,
        totalQuizzes: 15,
        averageScore: 72.5,
      ),
      SubjectModel(
        id: '4',
        name: 'الأحياء',
        description: 'علم الأحياء والوراثة',
        icon: '🧬',
        color: '0xFFFF9800',
        chaptersCount: 9,
        progress: 0.40,
        totalQuizzes: 12,
        averageScore: 68.0,
      ),
    ];
  }

  static List<ChapterModel> getMockChapters(String subjectId) {
    return [
      ChapterModel(
        id: '1',
        subjectId: subjectId,
        name: 'الفصل الأول: المقدمة',
        order: 1,
        questionsCount: 25,
        progress: 1.0,
        isCompleted: true,
      ),
      ChapterModel(
        id: '2',
        subjectId: subjectId,
        name: 'الفصل الثاني: المفاهيم الأساسية',
        order: 2,
        questionsCount: 30,
        progress: 0.80,
        isCompleted: false,
      ),
      ChapterModel(
        id: '3',
        subjectId: subjectId,
        name: 'الفصل الثالث: التطبيقات',
        order: 3,
        questionsCount: 35,
        progress: 0.60,
        isCompleted: false,
      ),
      ChapterModel(
        id: '4',
        subjectId: subjectId,
        name: 'الفصل الرابع: المسائل المتقدمة',
        order: 4,
        questionsCount: 40,
        progress: 0.30,
        isCompleted: false,
      ),
    ];
  }

  static List<QuestionModel> getMockQuestions({int count = 10}) {
    final questions = [
      QuestionModel(
        id: '1',
        content: 'ما هو ناتج جمع 5 + 7؟',
        type: 'multiple_choice',
        options: {'A': '10', 'B': '11', 'C': '12', 'D': '13'},
        correctAnswer: 'C',
        explanation: 'عند جمع 5 + 7 نحصل على 12',
        difficulty: 'easy',
        skill: 'remember',
        referencePage: 'ص 15',
      ),
      QuestionModel(
        id: '2',
        content: 'الجذر التربيعي للعدد 144 يساوي:',
        type: 'multiple_choice',
        options: {'A': '10', 'B': '11', 'C': '12', 'D': '14'},
        correctAnswer: 'C',
        explanation: 'الجذر التربيعي لـ 144 هو 12 لأن 12 × 12 = 144',
        difficulty: 'easy',
        skill: 'understand',
        referencePage: 'ص 28',
      ),
      QuestionModel(
        id: '3',
        content: 'إذا كان س + 5 = 12، فما قيمة س؟',
        type: 'multiple_choice',
        options: {'A': '5', 'B': '6', 'C': '7', 'D': '8'},
        correctAnswer: 'C',
        explanation: 'بطرح 5 من الطرفين: س = 12 - 5 = 7',
        difficulty: 'medium',
        skill: 'apply',
        referencePage: 'ص 42',
      ),
      QuestionModel(
        id: '4',
        content: 'العدد الأولي هو عدد لا يقبل القسمة إلا على نفسه وعلى الواحد',
        type: 'true_false',
        options: {'A': 'صح', 'B': 'خطأ'},
        correctAnswer: 'A',
        explanation: 'تعريف العدد الأولي صحيح',
        difficulty: 'easy',
        skill: 'remember',
        referencePage: 'ص 10',
      ),
      QuestionModel(
        id: '5',
        content: 'ما هو حاصل ضرب 8 × 9؟',
        type: 'multiple_choice',
        options: {'A': '70', 'B': '71', 'C': '72', 'D': '73'},
        correctAnswer: 'C',
        explanation: '8 × 9 = 72',
        difficulty: 'easy',
        skill: 'remember',
        referencePage: 'ص 20',
      ),
      QuestionModel(
        id: '6',
        content: 'إذا كانت مساحة المربع 64 سم²، فما طول ضلعه؟',
        type: 'multiple_choice',
        options: {'A': '6 سم', 'B': '7 سم', 'C': '8 سم', 'D': '9 سم'},
        correctAnswer: 'C',
        explanation: 'طول الضلع = الجذر التربيعي للمساحة = √64 = 8 سم',
        difficulty: 'medium',
        skill: 'apply',
        referencePage: 'ص 55',
      ),
      QuestionModel(
        id: '7',
        content: 'حل المعادلة: 2س - 4 = 10',
        type: 'multiple_choice',
        options: {'A': 'س = 5', 'B': 'س = 6', 'C': 'س = 7', 'D': 'س = 8'},
        correctAnswer: 'C',
        explanation: '2س = 14، إذن س = 7',
        difficulty: 'medium',
        skill: 'apply',
        referencePage: 'ص 65',
      ),
      QuestionModel(
        id: '8',
        content: 'ما هو محيط الدائرة التي نصف قطرها 7 سم؟ (استخدم π = 22/7)',
        type: 'multiple_choice',
        options: {'A': '40 سم', 'B': '42 سم', 'C': '44 سم', 'D': '46 سم'},
        correctAnswer: 'C',
        explanation:
            'محيط الدائرة = 2 × π × نصف القطر = 2 × (22/7) × 7 = 44 سم',
        difficulty: 'medium',
        skill: 'apply',
        referencePage: 'ص 78',
      ),
      QuestionModel(
        id: '9',
        content:
            'إذا كان متوسط ثلاثة أعداد هو 15، وكان مجموعها 45، فالعبارة صحيحة',
        type: 'true_false',
        options: {'A': 'صح', 'B': 'خطأ'},
        correctAnswer: 'A',
        explanation: 'متوسط الأعداد = المجموع ÷ العدد = 45 ÷ 3 = 15',
        difficulty: 'medium',
        skill: 'analyze',
        referencePage: 'ص 90',
      ),
      QuestionModel(
        id: '10',
        content: 'ما هو ناتج 15% من 200؟',
        type: 'multiple_choice',
        options: {'A': '25', 'B': '30', 'C': '35', 'D': '40'},
        correctAnswer: 'B',
        explanation: '15% من 200 = (15/100) × 200 = 30',
        difficulty: 'hard',
        skill: 'apply',
        referencePage: 'ص 102',
      ),
      QuestionModel(
        id: '11',
        content: 'حل المعادلة التربيعية: س² - 5س + 6 = 0',
        type: 'multiple_choice',
        options: {
          'A': 'س = 2 أو س = 3',
          'B': 'س = 1 أو س = 6',
          'C': 'س = -2 أو س = -3',
          'D': 'س = 0 أو س = 5',
        },
        correctAnswer: 'A',
        explanation: 'بالتحليل: (س - 2)(س - 3) = 0، إذن س = 2 أو س = 3',
        difficulty: 'hard',
        skill: 'analyze',
        referencePage: 'ص 125',
      ),
      QuestionModel(
        id: '12',
        content:
            'إذا كانت النسبة بين عددين 3:4 ومجموعهما 35، فما قيمة العدد الأكبر؟',
        type: 'multiple_choice',
        options: {'A': '15', 'B': '18', 'C': '20', 'D': '24'},
        correctAnswer: 'C',
        explanation: 'مجموع النسب = 7، العدد الأكبر = (4/7) × 35 = 20',
        difficulty: 'hard',
        skill: 'analyze',
        referencePage: 'ص 138',
      ),
    ];

    return questions.take(count).toList();
  }
}
