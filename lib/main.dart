import 'package:flutter/material.dart';
import 'login.dart';
import 'helper/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DBHelper.initialize();

    return MaterialApp(
      title: 'ECBS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Enrichment Classes Booking System'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = "";

  void checkLoginStatus() async {
    String? result = "";
    while (email.isEmpty) {
      result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(title: widget.title)));

      setState(() {
        email = result ?? "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Text(email),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      //Navigator.pop(context);
                    },
                    child: const Text("Go back!")))
          ],
        ));
  }
}
