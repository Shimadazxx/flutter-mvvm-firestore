import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart'; // Import model
import '../viewmodels/task_viewmodels.dart'; // Import viewmodel

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  void _showForm(BuildContext context, [Task? task]) {
    if (task != null) {
      _titleController.text = task.title;
      _detailController.text = task.detail;
    } else {
      _titleController.clear();
      _detailController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Tugas'),
              ),
              TextField(
                controller: _detailController,
                decoration: const InputDecoration(labelText: 'Detail Tugas'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final title = _titleController.text;
                  final detail = _detailController.text;

                  if (title.isNotEmpty && detail.isNotEmpty) {
                    final viewModel = context.read<TaskViewModel>();

                    if (task == null) {
                      await viewModel.addTask(title, detail);
                    } else {
                      await viewModel.updateTask(task.id, title, detail);
                    }

                    if (context.mounted) Navigator.of(context).pop();
                  }
                },
                child: Text(task == null ? 'Simpan' : 'Perbarui'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<TaskViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      body: StreamBuilder<List<Task>>(
        stream: viewModel.tasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada tugas.'));
          }

          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(task.detail),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showForm(context, task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            viewModel.deleteTask(task.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tugas dihapus')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}