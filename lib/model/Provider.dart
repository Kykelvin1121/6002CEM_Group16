// ignore_for_file: file_names

class Provider {
  final int id;
  final String name;
  final String email;
  final String password;

  Provider(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password};
  }
}
