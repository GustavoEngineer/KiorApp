import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/data/models/task.dart';
import 'package:kiorapp/presentation/providers/task_provider.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';

class NewTaskScreen extends ConsumerStatefulWidget {
  final Task? task;
  const NewTaskScreen({super.key, this.task});

  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedTimeController = TextEditingController();
  DateTime? _dueDate;
  int? _selectedTagId;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskNameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate;
      _estimatedTimeController.text =
          widget.task!.estimatedTime?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    _estimatedTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tags = ref.watch(tagProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _taskNameController,
                            decoration: const InputDecoration(
                              hintText: 'New Task',
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a task name';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _estimatedTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Tiempo estimado (horas)',
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      title: 'Time',
                      valueWidget: GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);

                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: (_dueDate ?? today).isBefore(today)
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
                        child: Text(
                          _dueDate == null
                              ? 'Select date'
                              : _dueDate!.toLocal().toString().split(' ')[0],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    _buildInfoRow(
                      icon: Icons.label_outline,
                      title: 'Label',
                      valueWidget: DropdownButton<int>(
                        value: _selectedTagId,
                        hint: const Text('Select'),
                        underline: const SizedBox.shrink(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedTagId = newValue;
                          });
                        },
                        items: tags.map((tag) {
                          return DropdownMenuItem<int>(
                            value: tag.id,
                            child: Text(tag.name),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final estimatedTime = double.tryParse(
                            _estimatedTimeController.text,
                          );
                          final task = Task(
                            id: widget.task?.id,
                            name: _taskNameController.text,
                            description: _descriptionController.text,
                            dueDate: _dueDate,
                            estimatedTime: estimatedTime,
                          );
                          if (widget.task == null) {
                            ref.read(taskProvider.notifier).addTask(task);
                          } else {
                            ref.read(taskProvider.notifier).updateTask(task);
                          }

                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Save Task'),
                    ),
                  ],
                ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
              const Spacer(),
              valueWidget,
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
