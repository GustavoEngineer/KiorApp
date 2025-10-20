class Task {
  final int? id;
  final String name;
  final String? description;
  final DateTime? dueDate;
  final DateTime? startDate;
  final int priority;
  final bool isCompleted;
  final double? estimatedTime;
  final List<int> tagIds;

  Task({
    this.id,
    required this.name,
    this.description,
    this.dueDate,
    this.startDate,
    this.priority = 0,
    this.isCompleted = false,
    this.estimatedTime,
    this.tagIds = const [],
  });

  factory Task.fromMap(
    Map<String, dynamic> map, {
    List<int> tagIds = const [],
  }) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate:
          map['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) : null,
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'])
          : null,
      priority: map['priority'],
      isCompleted: map['isCompleted'] == 1,
      estimatedTime: map['estimatedTime'],
      tagIds: tagIds,
    );
  }

  Map<String, dynamic> toMap() {
    DateTime? finalStartDate = startDate;
    if (dueDate != null && estimatedTime != null) {
      finalStartDate = dueDate!.subtract(
        Duration(minutes: estimatedTime!.toInt()),
      );
    }

    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'startDate': finalStartDate?.millisecondsSinceEpoch,
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'estimatedTime': estimatedTime,
      // tagIds se maneja por separado en el repositorio
    };
  }

  Task copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? dueDate,
    DateTime? startDate,
    int? priority,
    bool? isCompleted,
    double? estimatedTime,
    List<int>? tagIds,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      tagIds: tagIds ?? this.tagIds,
    );
  }
}
