// ignore_for_file: file_names

class Student {
  final int id;
  final String name;
  final String email;
  final String password;

  Student(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }
}
