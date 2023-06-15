import 'package:flutter/material.dart';
import 'register.dart';
import 'model/Student.dart';
import 'helper/db_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    return null;
  }

  void navigateBack(Student s) {
    Navigator.pop(context, s.name);
  }

  void invalidCredential() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
  }

  void onSubmitBtnPressed() async {
    if (_formKey.currentState!.validate()) {
      Student? s = await DBHelper.getStudent(
          emailController.text, passwordController.text);

      if (s != null) {
        navigateBack(s);
      } else {
        invalidCredential();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill input")));
    }
  }

  void onRegisterBtnPressed() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegisterPage(title: widget.title)));

    emailController.text = result ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 16),
                      child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Email"),
                          validator: emailValidator)),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: passwordValidator)),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: onSubmitBtnPressed,
                              child: const Text("Submit")))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: onRegisterBtnPressed,
                              child: const Text("Register"))))
                ]),
          ),
        ));
  }
}
