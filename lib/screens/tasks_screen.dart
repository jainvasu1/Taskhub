import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import 'package:taskhub/screens/task_counter.dart'; // ADDED

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Future<List<Task>>
  _tasksFuture; //late means you are intializing the variable inside initstate and furure means list of tasks added in future or store in future in sp.
  List<Task> _tasks = [];
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _tasksFuture = StorageService.loadTasks();
  }

  // COMMON METHOD (CLEAN CODE)
  void updateBadge() {
    incompleteTaskCount.value = _tasks.where((t) => !t.isCompleted).length;
  }

  Future<void> _refreshTasks() async {
    final data = await StorageService.loadTasks();
    setState(() {
      _tasks = data;
    });
    updateBadge(); //  ADDED
  }

  List<Task> get filteredTasks {
    if (_filter == 'Pending') {
      return _tasks.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      return _tasks.where((t) => t.isCompleted).toList();
    }
    return _tasks;
  }

  void _deleteTask(Task task) {
    final index = _tasks.indexOf(task);
    final removed = _tasks[index];

    setState(() {
      _tasks.removeAt(index);
    });

    StorageService.saveTasks(_tasks);
    updateBadge(); // ADDED

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task deleted"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              _tasks.insert(index, removed);
            });
            StorageService.saveTasks(_tasks);
            updateBadge(); // ADDED
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          // LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR STATE
          if (snapshot.hasError) {
            //snapshot means current state of future.
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

          // FIRST LOAD
          if (_tasks.isEmpty && snapshot.hasData) {
            _tasks = snapshot.data!;
            updateBadge(); // ADDED
          }

          // EMPTY STATE
          if (_tasks.isEmpty) {
            return const Center(child: Text("No Tasks Yet"));
          }

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: Column(
              children: [
                // FILTER ROW
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

                // TASK LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return Dismissible(
                        key: ValueKey(task.id),

                        // background color on swipe
                        background: Container(color: Colors.red),

                        // confirm dialog before delete
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

                        onDismissed: (_) => _deleteTask(task),

                        child: TaskTile(
                          task: task,
                          onChanged: () {
                            setState(() {});
                            StorageService.saveTasks(_tasks);
                            updateBadge(); // ADDED
                          },
                          onDelete: () => _deleteTask(task),

                          //  EDIT VIA TAP
                          onTap: () async {
                            final updatedTask = await Navigator.pushNamed(
                              context,
                              '/add-task',
                              arguments: task,
                            );

                            if (updatedTask != null && updatedTask is Task) {
                              setState(() {
                                task.title = updatedTask.title;
                                task.description = updatedTask.description;
                                task.priority = updatedTask.priority;
                              });

                              StorageService.saveTasks(_tasks);
                              updateBadge();
                            }
                          },
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
            updateBadge(); // ADDED
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
  final VoidCallback onTap; // ADDED

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
    required this.onTap, // ADDED
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap, //  TAP SUPPORT

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

        // priority label
        subtitle: Text(task.priority.label),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onTap),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
