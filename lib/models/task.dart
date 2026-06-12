import 'package:uuid/uuid.dart';

enum TaskPriority {
  low(1, 'Low'),
  medium(2, 'Medium'),
  high(3, 'High'),
  urgent(4, 'Urgent');

  const TaskPriority(this.value, this.label);

  final int value;
  final String label;
}

class Task {
  static const Uuid _uuid = Uuid();

  final String id;
  final String timestamp;
  String title;
  String description;
  bool isCompleted;
  TaskPriority priority;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
  }) : id = id ?? _uuid.v4(),
       timestamp = DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      priority: TaskPriority.values[map['priority']],
    );
  }
}
