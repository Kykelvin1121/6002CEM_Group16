// ignore_for_file: file_names

class Booking {
  int id;
  int classroomId;
  int providerId;
  DateTime sessionStartTime;
  DateTime sessionEndTime;
  int numStudent;
  int? attendedStudent;

  Booking(
      {required this.id,
      required this.classroomId,
      required this.providerId,
      required this.sessionStartTime,
      required this.sessionEndTime,
      required this.numStudent,
      this.attendedStudent});

  bool setAttendance(int attendance) {
    bool valid = false;

    if (attendance >= 0 && attendance <= numStudent) {
      attendedStudent = attendance;
      valid = true;
    }
    return valid;
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomId': classroomId,
      'providerId': providerId,
      'sessionStartTime': sessionStartTime.toString(),
      'sessionEndTime': sessionEndTime.toString(),
      'numStudent': numStudent,
      'attendedStudent': attendedStudent ?? 0
    };
  }
}
