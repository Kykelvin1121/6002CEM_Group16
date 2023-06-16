import 'package:flutter/material.dart';
import 'model/Provider.dart';
import 'helper/db_helper.dart';
import 'model/Booking.dart';
import 'model/Classroom.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key, required this.provider});
  final Provider? provider;

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final _formKey = GlobalKey<FormState>();

  List<Classroom>? classroomList;
  int selectedClassroom = -1;
  String startDateInput = DateTime.now().toString();
  String endDateInput = DateTime.now().toString();
  TextEditingController numStudentController = TextEditingController();

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
      Booking b = Booking(
          id: 0,
          classroomId: selectedClassroom,
          providerId: widget.provider!.id,
          sessionStartTime: DateTime.parse(startDateInput),
          sessionEndTime: DateTime.parse(endDateInput),
          numStudent: int.parse(numStudentController.text),
          attendedStudent: 0);

      int result = await DBHelper.insertBooking(b);

      switch (result) {
        case 0:
          showMessage("Classroom successfully booked");
          navigateBack();
          break;
        case 1:
          showMessage("Database Not Connected");
          break;
        case 2:
          showMessage("Classroom Not Found");
          break;
        case 3:
          showMessage("Too Many Students");
          break;
        case 4:
          showMessage("Classroom is booked by other session");
          break;
        case 5:
          showMessage("End date cannot earlier than start date");
          break;
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
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: DropdownButton<int>(
                        value: selectedClassroom,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (int? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedClassroom = value!;
                          });
                        },
                        items: classroomList
                            ?.map<DropdownMenuItem<int>>((Classroom value) {
                          return DropdownMenuItem<int>(
                            value: value.id,
                            child: Text(value.name),
                          );
                        }).toList())),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: TextFormField(
                        controller: numStudentController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Number of Students"),
                        validator: basicValidator)),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        initialValue: startDateInput,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Start Date',
                        timeLabelText: "Start Time",
                        onChanged: (val) => setState(() {
                              startDateInput = val;
                            }))),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    child: DateTimePicker(
                        type: DateTimePickerType.dateTimeSeparate,
                        initialValue: endDateInput,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'End Date',
                        timeLabelText: "End Time",
                        onChanged: (val) => setState(() {
                              endDateInput = val;
                            }))),
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
