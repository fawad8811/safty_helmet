import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:safety_helmet/models/workersModel.dart';

class AdminWorkersProvider extends ChangeNotifier {
  FirebaseDatabase database = FirebaseDatabase.instance;

  List<WorkersModel> workersList = [];

  List<WorkersModel> get getWorkersList {
    return workersList;
  }

  Future<void> fetchAllWorkers() async {
    try {
      final node1 = await database.ref('Zahid_Mehmood').get();
      final node2 = await database.ref('Syed_Ghafran_Haider').get();

      final node1Worker = WorkersModel(
        workerId: node1.key!,
        workerName: node1.child('name').value.toString(),
        workerStatus: node1.child('n1').value.toString() == "1" ? true : false,
        workerHelmetStatus:
            node1.child('helmetStatus').value.toString() == "true"
                ? true
                : false,
        workerEmergencyAlarm:
            node1.child('fire1').value.toString() == "1" ? true : false,
        workerLatitude: double.parse(node1.child('latitude').value.toString()),
        workerLongitude:
            double.parse(node1.child('longitude').value.toString()),
      );

      final node2Worker = WorkersModel(
        workerId: node2.key!,
        workerName: node2.child('name').value.toString(),
        workerStatus: node2.child('n2').value.toString() == "1" ? true : false,
        workerHelmetStatus:
            node2.child('helmetStatus').value.toString() == "1" ? true : false,
        workerEmergencyAlarm:
            node2.child('fire2').value.toString() == "1" ? true : false,
        workerLatitude: double.parse(node2.child('latitude').value.toString()),
        workerLongitude:
            double.parse(node2.child('longitude').value.toString()),
      );

      final list = [node1Worker, node2Worker];

      workersList = list;

      notifyListeners();

      database.ref('Zahid_Mehmood').onValue.listen((event) {
        final fire1Value = event.snapshot.child('fire1').value.toString();
        final gas1Value = event.snapshot.child('gas1').value.toString();
        final n1Value = event.snapshot.child('n1').value.toString();
        final helmetStatus =
            event.snapshot.child('helmetStatus').value.toString();
        final longitude = event.snapshot.child('longitude').value.toString();
        final latitude = event.snapshot.child('latitude').value.toString();

        workersList[0].workerEmergencyAlarm = fire1Value == '1'
            ? true
            : gas1Value == '1'
                ? true
                : false;
        workersList[0].workerHelmetStatus =
            helmetStatus == 'true' ? true : false;
        workersList[0].workerStatus = n1Value == '0' ? false : true;
        workersList[0].workerLongitude = double.tryParse(longitude);
        workersList[0].workerLatitude = double.tryParse(latitude);

        notifyListeners();
      });

      database.ref('Syed_Ghafran_Haider').onValue.listen((event) {
        final fire2Value = event.snapshot.child('fire2').value.toString();
        final gas2Value = event.snapshot.child('gas2').value.toString();
        final n1Value = event.snapshot.child('n2').value.toString();
        final helmetStatus =
            event.snapshot.child('helmetStatus').value.toString();
        final longitude = event.snapshot.child('longitude').value.toString();
        final latitude = event.snapshot.child('latitude').value.toString();

        workersList[1].workerEmergencyAlarm = fire2Value == '1'
            ? true
            : gas2Value == '1'
                ? true
                : false;
        workersList[1].workerHelmetStatus =
            helmetStatus == 'true' ? true : false;
        workersList[1].workerStatus = n1Value == '0' ? false : true;
        workersList[1].workerLongitude = double.tryParse(longitude);
        workersList[1].workerLatitude = double.tryParse(latitude);

        notifyListeners();
      });
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> changeEmergencyAlarmStatus(bool value, String userName) async {
    try {
      if (userName == 'Zahid Mehmood') {
        await database
            .ref('Zahid_Mehmood')
            .update({'fire1': value ? '1' : '0', 'gas1': value ? '1' : '0'});
      }

      if (userName == 'Syed Ghafran Haider') {
        await database
            .ref('Syed_Ghafran_Haider')
            .update({'fire2': value ? '1' : '0', 'gas2': value ? '1' : '0'});
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }
}
