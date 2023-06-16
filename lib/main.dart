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
  String name = "";

  void checkLoginStatus() async {
    String? result = "";
    while (name.isEmpty) {
      result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(title: widget.title)));

      setState(() {
        name = result ?? "";
      });
    }
  }

  void retrieveClassInfo() async {
    if (name.isEmpty) return;
  }

  void onFloatingBtnPressed() {}

  void onLogoutBtnPressed() {
    setState(() {
      name = "";
    });
    checkLoginStatus();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLoginStatus());
    WidgetsBinding.instance.addPostFrameCallback((_) => retrieveClassInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text("Hi, $name",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary))),
          Container(
            margin: const EdgeInsets.all(10),
            width: 300,
            height: 200,
            alignment: Alignment.centerLeft,
            color: Colors.green,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Your classes\nxxx on today\nxxx on this week",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: 300,
            height: 200,
            alignment: Alignment.centerLeft,
            color: Colors.blue,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                    "Students' attendance rate\nthis week: xx%\nlast week: xx%",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: onLogoutBtnPressed,
                      child: const Text("Logout"))))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onFloatingBtnPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
