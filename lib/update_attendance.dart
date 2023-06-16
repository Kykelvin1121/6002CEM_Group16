import 'package:flutter/material.dart';
import 'helper/db_helper.dart';
import 'model/Booking.dart';
import 'model/Classroom.dart';
import 'package:intl/intl.dart';

class UpdateAttendancePage extends StatefulWidget {
  const UpdateAttendancePage({super.key, required this.booking});
  final Booking? booking;

  @override
  State<UpdateAttendancePage> createState() => _UpdateAttendancePageState();
}

class _UpdateAttendancePageState extends State<UpdateAttendancePage> {
  final _formKey = GlobalKey<FormState>();

  List<Classroom>? classroomList;
  int selectedClassroom = -1;
  TextEditingController attendanceController = TextEditingController();

  Future<void> getClassroomList() async {
    classroomList = await DBHelper.getAllClassroom();
    if (classroomList != null) {
      setState(() {
        selectedClassroom = classroomList?[0].id ?? -1;
      });
    }
  }

  String? basicValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter valid value";
    }
    return null;
  }

  void navigateBack() {
    Navigator.pop(context);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void onSubmitBtnPressed() async {
    if (_formKey.currentState!.validate()) {
      bool result = await DBHelper.updateBookingAttendance(
          widget.booking!.id, int.parse(attendanceController.text));

      if (result) {
        showMessage("Classroom successfully booked");
        navigateBack();
      } else {
        showMessage("Failed to set attendance.");
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill input")));
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
        title: const Text("Update Attendance"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: Text(
                        "Classroom: ${classroomList?[widget.booking?.classroomId ?? 0].name}")),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: Text(
                        "Number of Students: ${widget.booking?.numStudent}")),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: TextFormField(
                        controller: attendanceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Number of Students Attended"),
                        validator: basicValidator)),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: Text(
                        "Session Start Date: ${DateFormat('dd-MM-yyyy – kk:mm').format(widget.booking!.sessionStartTime)}")),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: Text(
                        "Session End Date: ${DateFormat('dd-MM-yyyy – kk:mm').format(widget.booking!.sessionEndTime)}")),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: onSubmitBtnPressed,
                            child: const Text("Update")))),
              ]),
        ),
      ),
    );
  }
}
