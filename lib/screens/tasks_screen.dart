import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Future<List<Task>> _tasksFuture;
  List<Task> _tasks = [];
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _tasksFuture = StorageService.loadTasks();
  }

  Future<void> _refreshTasks() async {
    final data = await StorageService.loadTasks();
    setState(() {
      _tasks = data;
    });
  }

  List<Task> get filteredTasks {
    if (_filter == 'Pending') {
      return _tasks.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      return _tasks
          .where((t) => t.isCompleted)
          .toList(); ////where helps to filter out the data
    }
    return _tasks;
  }

  // FIXED: using Task instead of index to avoid mismatch with filtered list
  void _deleteTask(Task task) {
    final index = _tasks.indexOf(task);
    final removed = _tasks[index];

    setState(() {
      _tasks.removeAt(index);
    });

    StorageService.saveTasks(_tasks);

    ScaffoldMessenger.of(context).showSnackBar(
      //it manages snackbar(At the bottom) and materialBanner at the top.
      SnackBar(
        content: const Text("Task deleted"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              _tasks.insert(index, removed);
            });
            StorageService.saveTasks(_tasks);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Task>>(
        //here FutureBuilder is used to create widget based on the latest snapshot of interaction with a future.
        future:
            _tasksFuture, //here tasksFuture is private bcz it cant conflict with other tasks id or title.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error loading tasks"),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _tasksFuture = StorageService.loadTasks();
                      });
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (_tasks.isEmpty && snapshot.hasData) {
            _tasks = snapshot.data!;
          }

          if (_tasks.isEmpty) {
            return const Center(child: Text("No Tasks Yet"));
          }

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['All', 'Pending', 'Completed']
                      .map(
                        (f) => ChoiceChip(
                          label: Text(f),
                          selected: _filter == f,
                          onSelected: (_) {
                            setState(() {
                              _filter = f;
                            });
                          },
                        ),
                      )
                      .toList(),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return Dismissible(
                        key: ValueKey(task.id),
                        background: Container(color: Colors.red),
                        confirmDismiss: (_) async {
                          return await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete task?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        },

                        // FIXED
                        onDismissed: (_) => _deleteTask(task),

                        child: TaskTile(
                          task: task,
                          onChanged: () {
                            setState(() {});
                            StorageService.saveTasks(_tasks);
                          },
                          onDelete: () => _deleteTask(task),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.pushNamed(context, '/add-task');

          if (newTask != null && newTask is Task) {
            setState(() {
              _tasks.add(newTask);
            });
            StorageService.saveTasks(_tasks);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// TaskTile Widget
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            task.isCompleted = value!;
            onChanged();
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.priority.label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedTask = await Navigator.pushNamed(
                  context,
                  '/add-task',
                  arguments: task,
                );

                if (updatedTask != null && updatedTask is Task) {
                  task.title = updatedTask.title;
                  task.description = updatedTask.description;
                  task.priority = updatedTask.priority;

                  onChanged();
                }
              },
            ),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
        onTap: () async {
          final updatedTask = await Navigator.pushNamed(
            context,
            '/add-task',
            arguments: task,
          );

          if (updatedTask != null && updatedTask is Task) {
            task.title = updatedTask.title;
            task.description = updatedTask.description;
            task.priority = updatedTask.priority;

            onChanged();
          }
        },
      ),
    );
  }
}
