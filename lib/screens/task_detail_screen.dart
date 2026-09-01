import 'package:flutter/material.dart';
import '../models/task.dart';

// This screen does three jobs at once, controlled by the _isEditing flag:
//   1. View task details (default)
//   2. Edit the title/description (when _isEditing is true)
//   3. Mark the task as completed, or delete it
class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isCompleted;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the controllers and local state with the task's
    // current values, since this screen can view AND edit it.
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Builds an updated Task from whatever is currently in the form,
  // then sends it back to HomeScreen.
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: _isCompleted,
      );
      Navigator.pop(context, updatedTask);
    }
  }

  void _toggleCompleted() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
    // If we're just viewing (not editing), save this change immediately.
    if (!_isEditing) {
      final updatedTask = Task(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isCompleted: _isCompleted,
      );
      Navigator.pop(context, updatedTask);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // close the dialog
              Navigator.pop(context, 'delete'); // go back and signal delete
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Task Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            tooltip: _isEditing ? 'Save' : 'Edit',
            onPressed: () {
              if (_isEditing) {
                _saveChanges();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _isEditing
                  ? TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    )
                  : Text(
                      _titleController.text,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 16),
              _isEditing
                  ? TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    )
                  : Text(
                      _descriptionController.text.isEmpty
                          ? 'No description'
                          : _descriptionController.text,
                      style: const TextStyle(fontSize: 16),
                    ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (_) => _toggleCompleted(),
                  ),
                  Text(
                    _isCompleted ? 'Completed' : 'Mark as completed',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
