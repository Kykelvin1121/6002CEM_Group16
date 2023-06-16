import 'package:flutter/material.dart';
import 'model/Provider.dart';
import 'helper/db_helper.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key, required this.provider});
  final Provider? provider;

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
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

  void navigateBack() {
    Navigator.pop(context);
  }

  void invalidCredential() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
  }

  void onSubmitBtnPressed() async {
    if (_formKey.currentState!.validate()) {
      Provider? s = await DBHelper.getProvider(
          emailController.text, passwordController.text);

      if (s != null) {
        navigateBack();
      } else {
        invalidCredential();
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill input")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Booking List"),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: Text("Login",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary))),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: emailValidator)),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password"),
                        validator: passwordValidator)),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: onSubmitBtnPressed,
                            child: const Text("Submit")))),
              ]),
        ),
      ),
    );
  }
}
