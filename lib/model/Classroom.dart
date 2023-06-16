// ignore_for_file: file_names

class Classroom {
  int id;
  int maxStudent;
  String name;
  Classroom({required this.id, required this.name, required this.maxStudent});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'maxStudent': maxStudent};
  }
}
