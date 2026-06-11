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
  static const Uuid _uuid =
      Uuid(); //// Bad: If uuid is public, external code can corrupt your identifiers

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
  }) : id = id ?? _uuid.v4(), //If id is not provided → generate a UUID
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
  } //Convert object → Map so it can easily access via api or json

  factory Task.fromMap(Map<String, dynamic> map) {
    //Convert Map → Task object
    if (!map.containsKey('id') || !map.containsKey('title')) {
      //Ensures required fields exist.
      throw ArgumentError('Invalid map data for Task');
    }

    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      priority: TaskPriority.values[map['priority']],
    );
  }
}

//Safe defaults for missing values
//Converts integer →enum using
