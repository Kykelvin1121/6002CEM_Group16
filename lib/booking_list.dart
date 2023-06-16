import 'package:flutter/material.dart';
import 'package:flutter_application_1/book_classroom.dart';
import 'register.dart';
import 'model/Provider.dart';
import 'helper/db_helper.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.provider});
  final Provider? provider;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
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

  void onSubmitBtnPressed() async {
    if (_formKey.currentState!.validate()) {
      bool valid = false;
      String msg = "";

      if (valid) {
        navigateBack();
      } else {}
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill input")));
    }
  }

  void onBookingBtnPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddClassPage(provider: widget.provider)));
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
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: onBookingBtnPressed,
                            child: const Text("Booking Class"))))
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onBookingBtnPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
