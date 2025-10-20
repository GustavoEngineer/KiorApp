import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';

class NewTaskScreen extends ConsumerStatefulWidget {
  final Task? task;
  final DateTime? selectedDate;
  const NewTaskScreen({super.key, this.task, this.selectedDate});

  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedTimeController = TextEditingController();
  DateTime? _dueDate;
  List<int> _selectedTagIds = [];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskNameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate;
      _estimatedTimeController.text =
          widget.task!.estimatedTime?.toString() ?? '';
      _selectedTagIds = List<int>.from(widget.task!.tagIds);
    } else if (widget.selectedDate != null) {
      _dueDate = widget.selectedDate;
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    _estimatedTimeController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final estimatedTime = double.tryParse(_estimatedTimeController.text);
      final task = Task(
        id: widget.task?.id,
        name: _taskNameController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        estimatedTime: estimatedTime,
        tagIds: _selectedTagIds,
      );
      if (widget.task == null) {
        ref.read(taskProvider.notifier).addTask(task);
      } else {
        ref.read(taskProvider.notifier).updateTask(task);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(tagProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create New Task' : 'Edit Task'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task Name', style: textTheme.bodySmall),
                      TextFormField(
                        controller: _taskNameController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        style: textTheme.headlineSmall,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description', style: textTheme.bodySmall),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          isDense: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0,
                            ),
                          ),
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Category', style: textTheme.bodySmall),
                      const SizedBox(height: 8),
                      if (tags.isEmpty)
                        Text('no categories', style: textTheme.bodyLarge)
                      else
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: tags.map((tag) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(tag.name),
                                  labelStyle: _selectedTagIds.contains(tag.id)
                                      ? TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )
                                      : textTheme.bodyLarge,
                                  selected: _selectedTagIds.contains(tag.id),
                                  selectedColor: Theme.of(context).primaryColor,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: _selectedTagIds.contains(tag.id)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(
                                              context,
                                            ).primaryColor.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedTagIds.add(tag.id!);
                                      } else {
                                        _selectedTagIds.remove(tag.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date', style: textTheme.bodySmall),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _dueDate?.toLocal().toString().split(
                                        ' ',
                                      )[0] ??
                                      '',
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async {
                                  final now = DateTime.now();
                                  final today = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                  );
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        (_dueDate ?? today).isBefore(today)
                                        ? today
                                        : (_dueDate ?? today),
                                    firstDate: today,
                                    lastDate: DateTime(2101),
                                    initialEntryMode: DatePickerEntryMode.input,
                                  );
                                  if (picked != null && picked != _dueDate) {
                                    setState(() {
                                      _dueDate = picked;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('working hours', style: textTheme.bodySmall),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextFormField(
                              controller: _estimatedTimeController,
                              decoration: InputDecoration(
                                isDense: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _saveTask,
                    child: Text(
                      widget.task == null ? 'Create Task' : 'Update Task',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required Widget valueWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Theme.of(context).textTheme.bodySmall?.color),
              const SizedBox(width: 16),
              Expanded(child: valueWidget),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
