import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;

  TaskPriority _priority = TaskPriority.medium;
  bool _isCompleted = false;

  Task? existing;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is Task) {
      existing = args;

      _titleController.text = args.title;
      _descController.text = args.description;
      _priority = args.priority;
      _isCompleted = args.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void save() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: existing?.id,
        title: _titleController.text,
        description: _descController.text,
        priority: _priority,
        isCompleted: _isCompleted,
      );

      Navigator.pop(context, task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final edit = existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(edit ? "Edit Task" : "Add Task")),

      // FIX: prevents bottom overflow when keyboard appears
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            // FIX: ensures content moves above keyboard
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),

          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter title";
                    if (v.length < 3) return "Minimum 3 characters";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<TaskPriority>(
                  value: _priority,
                  items: TaskPriority.values
                      .map(
                        (p) => DropdownMenuItem(value: p, child: Text(p.label)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _priority = v!),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  value: _isCompleted,
                  onChanged: (v) => setState(() => _isCompleted = v),
                  title: const Text("Completed"),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: save,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Task"),
                  ),
                ),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
