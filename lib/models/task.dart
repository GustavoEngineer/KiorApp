class Task {
  final int? id;
  final String name;
  final String? description;
  final DateTime? dueDate;
  final String? label;
  final bool isCompleted;
  final DateTime? startDate;
  final int priority;

  Task({
    this.id,
    required this.name,
    this.description,
    this.dueDate,
    this.label,
    this.isCompleted = false,
    this.startDate,
    this.priority = 0,
  });

  // El método que faltaba
  Task copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? label,
    bool? isCompleted,
    DateTime? startDate,
    int? priority,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      label: label ?? this.label,
      isCompleted: isCompleted ?? this.isCompleted,
      startDate: startDate ?? this.startDate,
      priority: priority ?? this.priority,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: map['due_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['due_date'])
          : null,
      label: map['label'],
      isCompleted: map['is_completed'] == 1,
      startDate: map['start_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start_date'])
          : null,
      priority: int.tryParse(map['priority'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'due_date': dueDate?.millisecondsSinceEpoch,
      'label': label,
      'is_completed': isCompleted ? 1 : 0,
      'start_date': startDate?.millisecondsSinceEpoch,
      'priority': priority,
    };
  }
}
