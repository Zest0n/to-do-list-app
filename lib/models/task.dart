// This file defines what a single "Task" looks like in our app.
// Think of it as a blueprint: every task will have a title,
// a description, and a flag that says whether it's done or not.

class Task {
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}
