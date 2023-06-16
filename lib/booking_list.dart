import 'package:flutter/material.dart';
import 'package:flutter_application_1/book_classroom.dart';
import 'model/Provider.dart';
import 'model/Booking.dart';
import 'model/Classroom.dart';
import 'helper/db_helper.dart';
import 'update_attendance.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.provider});
  final Provider? provider;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Widget> widgets = [];
  List<Booking>? listData;
  List<Classroom>? classroomData;

  void navigateBack() {
    Navigator.pop(context);
  }

  void onBookingBtnPressed() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddClassPage(provider: widget.provider)));

    await getClassroomList();
  }

  void listItemPressed(int i) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateAttendancePage(booking: listData?[i])));

    await getClassroomList();
  }

  Widget getRow(int i) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: () => listItemPressed(i),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                  color: Colors.lightGreen),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Provider: ${widget.provider?.name}"),
                    Text(
                        "Classroom: ${classroomData?[listData?[i].classroomId ?? 0].name}"),
                    Text(
                        "Start Date Time: ${DateFormat('dd-MM-yyyy – kk:mm').format(listData?[i].sessionStartTime ?? DateTime.now())}"),
                    Text(
                        "End Date Time: ${DateFormat('dd-MM-yyyy – kk:mm').format(listData?[i].sessionEndTime ?? DateTime.now())}"),
                    Text(
                        "Number of Student: ${listData?[i].numStudent.toString()}"),
                    Text(
                        "Number of Student: ${listData?[i].attendedStudent.toString()}")
                  ]),
            )));
  }

  void loadData() async {
    listData = await DBHelper.getBookingListFromProvider(widget.provider!);

    if (listData != null) {
      for (int i = 0; i < (listData?.length ?? 0); ++i) {
        widgets.add(getRow(i));
      }
    }

    setState(() {
      widgets = List.from(widgets);
    });
  }

  Future<void> getClassroomList() async {
    classroomData = await DBHelper.getAllClassroom();
    if (classroomData != null) {
      loadData();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getClassroomList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Booking List"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: onBookingBtnPressed,
                        child: const Text("Booking Class")))),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: listData?.length,
                    itemBuilder: (BuildContext context, int position) {
                      return getRow(position);
                    })),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: onBookingBtnPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
