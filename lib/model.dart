class Task {
  String title;
  DateTime date;

  Task({required this.title, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      date: DateTime.parse(json['date']),
    );
  }
}
