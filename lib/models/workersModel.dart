
class WorkersModel {

  String workerId;
  String workerName;
  bool workerStatus;
  bool workerHelmetStatus;
  double? workerLongitude;
  double? workerLatitude;
  bool workerEmergencyAlarm;


  WorkersModel({
    required this.workerId,
    required this.workerName,
    required this.workerStatus,
    required this.workerHelmetStatus,
    required this.workerEmergencyAlarm,
    this.workerLongitude,
    this.workerLatitude
  });
}