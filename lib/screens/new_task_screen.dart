import 'package:flutter/material.dart';
import 'package:kiorapp/database/database_helper.dart';

class NewTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;
  const NewTaskScreen({super.key, this.task});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isCompleted = false;
  String? _selectedLabel;
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    _loadLabels();
    if (widget.task != null) {
      _taskNameController.text = widget.task!['name'] ?? '';
      _descriptionController.text = widget.task!['description'] ?? '';
      if (widget.task!['due_date'] != null) {
        _dueDate = DateTime.parse(widget.task!['due_date']);
      }
      _selectedLabel = widget.task!['label'];
      _isCompleted = widget.task!['is_completed'] == 1;
    }
  }

  Future<void> _loadLabels() async {
    final labels = await DatabaseHelper().getTags();
    setState(() {
      _labels = labels.map((e) => e['name'] as String).toList();
    });
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                    // 1. Fila del título y botón de cerrar
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

                    // 2. Campos de texto para nombre y descripción
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

                    // 3. Filas de contenido
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
                      valueWidget: DropdownButton<String>(
                        value: _selectedLabel,
                        hint: const Text('Select'),
                        underline: const SizedBox.shrink(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLabel = newValue;
                          });
                        },
                        items: _labels.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final task = {
                            'name': _taskNameController.text,
                            'description': _descriptionController.text,
                            'due_date': _dueDate?.toIso8601String(),
                            'label': _selectedLabel,
                            'is_completed': _isCompleted ? 1 : 0,
                          };

                          if (widget.task == null) {
                            await DatabaseHelper().insertTask(task);
                          } else {
                            final updatedTask = {
                              'id': widget.task!['id'],
                              ...task,
                            };
                            await DatabaseHelper().updateTask(updatedTask);
                          }

                          if (!mounted) return;
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

class TopDownPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  TopDownPageRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0); // Empieza desde arriba
          const end = Offset.zero; // Termina en su posición final
          const curve = Curves.easeOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        opaque: false,
      );
}
