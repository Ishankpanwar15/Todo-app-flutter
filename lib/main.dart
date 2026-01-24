import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(),
    );
  }
}

/* ---------------- TASK MODEL ---------------- */
class Task {
  final String id;
  final String title;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
  });
}

/* ---------------- TODO PAGE ---------------- */
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /* -------- INPUT -------- */
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: taskController,
              decoration: const InputDecoration(
                hintText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          /* -------- ADD BUTTON -------- */
          ElevatedButton(
            onPressed: () {
              final text = taskController.text.trim();
              if (text.isEmpty) return;

              setState(() {
                tasks.add(
                  Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: text,
                  ),
                );
                taskController.clear();
              });
            },
            child: const Text('Add Task'),
          ),

          const SizedBox(height: 10),
          /* -------- TASK LIST -------- */
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No tasks yet'))
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  key: Key(task.id),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    key: Key('tile-${task.id}'),
                    leading: Checkbox(
                      key: Key('checkbox-${task.id}'),
                      value: task.isDone,
                      onChanged: (value) {
                        setState(() {
                          task.isDone = value ?? false;
                        });
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
