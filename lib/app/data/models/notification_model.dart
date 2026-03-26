class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String body;
  final String? assignmentId;
  final bool isRead;
  final DateTime createdAt;

  // معلومات الاختبار المرتبط
  final String? assignmentTitle;
  final String? subjectName;
  final String? teacherName;
  final DateTime? dueDate;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.assignmentId,
    required this.isRead,
    required this.createdAt,
    this.assignmentTitle,
    this.subjectName,
    this.teacherName,
    this.dueDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      assignmentId: json['assignment_id'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      assignmentTitle: json['assignment_title'],
      subjectName: json['subject_name'],
      teacherName: json['teacher_name'],
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'assignment_id': assignmentId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'assignment_title': assignmentTitle,
      'subject_name': subjectName,
      'teacher_name': teacherName,
      'due_date': dueDate?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? body,
    String? assignmentId,
    bool? isRead,
    DateTime? createdAt,
    String? assignmentTitle,
    String? subjectName,
    String? teacherName,
    DateTime? dueDate,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      assignmentId: assignmentId ?? this.assignmentId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      assignmentTitle: assignmentTitle ?? this.assignmentTitle,
      subjectName: subjectName ?? this.subjectName,
      teacherName: teacherName ?? this.teacherName,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
