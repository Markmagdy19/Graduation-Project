import 'package:get/get.dart';
import '../db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  /// Adds a task to the database and updates the task list.
  Future<int> addTask({required Task task}) async {
    print('Adding task: ${task.title}');
    final int result = await DBHelper.insert(task);
    await fetchTasks();  // Ensure task list is updated after adding a task
    return result;
  }

  /// Fetches all tasks from the database and updates the task list.
  Future<void> fetchTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  /// Deletes a specific task from the database and updates the task list.
  Future<void> deleteTask(Task task) async {
    await DBHelper.delete(task);
    await fetchTasks();
  }

  /// Deletes all tasks from the database and updates the task list.
  Future<void> deleteAllTasks() async {
    await DBHelper.deleteAll();
    await fetchTasks();
  }

  /// Marks a task as completed in the database and updates the task list.
  Future<void> markTaskAsCompleted(int id) async {
    await DBHelper.update(id);
    await fetchTasks();
  }
}
