import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safety_helmet/models/workersModel.dart';

class WorkerProvider extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  User? _currentUserFirebase = FirebaseAuth.instance.currentUser;
  // late WorkersModel _currentUser;
  WorkersModel _currentUser = WorkersModel(workerId: "", workerName: "", workerStatus: false, workerHelmetStatus: false, workerEmergencyAlarm: false);

  WorkersModel get getCurrentUser {
    return _currentUser;
  }

  User? get getCurrentUserFirebase {
    return _currentUserFirebase;
  }

  Future<void> signUp(
      String userName, String userEmail, String userPassword) async {
    try {
      final response = await auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e.toString();
    }

    try {
      final response = await database.ref(userName).set({
        'name': userName,
        'userEmail': userEmail,
        'password': userPassword,
        'longitude': 0,
        'latitude': 0
      });
    } on FirebaseException catch (e) {
      throw e.toString();
    }
  }

  Future<void> login(String userEmail, String password) async {
    try {
      UserCredential response = await auth.signInWithEmailAndPassword(
          email: userEmail, password: password);

      _currentUserFirebase = response.user;

      // Fetching all the data here
      DataSnapshot globalData = await database.ref().get();

      if (userEmail == 'zahidN1@gmail.com') {
        DataSnapshot snapshot = await database.ref('Zahid_Mehmood').get();

        if (snapshot.exists) {
          final newWorker = WorkersModel(
              workerId: snapshot.key!,
              workerName: snapshot.child('name').value.toString(),
              workerStatus:
                  snapshot.child('n1').value.toString() == "1" ? true : false,
              workerHelmetStatus:
                  snapshot.child('helmetStatus').value.toString() == "true"
                      ? true
                      : false,
              workerEmergencyAlarm:
                  snapshot.child('fire1').value.toString() == "1"
                      ? true
                      : false);

          _currentUser = newWorker;

          await database.ref('Zahid_Mehmood').update({"n1": "1"});

          _currentUser.workerStatus = true;

          notifyListeners();
        }
      } else if (userEmail == 'ghafranN2@gmail.com') {
        DataSnapshot snapshot = await database.ref('Syed_Ghafran_Haider').get();

        if (snapshot.exists) {
          final newWorker = WorkersModel(
              workerId: snapshot.key!,
              workerName: snapshot.child('name').value.toString(),
              workerStatus:
                  snapshot.child('n2').value.toString() == "1" ? true : false,
              workerHelmetStatus:
                  snapshot.child('helmetStatus').value.toString() == "1"
                      ? true
                      : false,
              workerEmergencyAlarm:
                  snapshot.child('fire2').value.toString() == "1"
                      ? true
                      : false);

          _currentUser = newWorker;

          await database.ref('Syed_Ghafran_Haider').update({"n2": "1"});

          _currentUser.workerStatus = true;

          notifyListeners();
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> changeEmergencyAlarmStatus(bool value, String userName) async {
    try {
      if (userName == 'Zahid Mehmood') {
        _currentUser.workerEmergencyAlarm = value;

        notifyListeners();

        await database
            .ref('Zahid_Mehmood')
            .update({'fire1': value ? '1' : '0', 'gas1': value ? '1' : '0'});
      }

      if (userName == 'Syed Ghafran Haider') {
        _currentUser.workerEmergencyAlarm = value;

        notifyListeners();

        await database
            .ref('Syed_Ghafran_Haider')
            .update({'fire2': value ? '1' : '0', 'gas2': value ? '1' : '0'});
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> changeLongitudeLatitude(
      String longitude, String latitude, String userName) async {
    double dlongitude = double.tryParse(longitude)!;
    double dlatitude = double.tryParse(latitude)!;

    try {
      if (userName == 'Zahid Mehmood') {
        await database
            .ref('Zahid_Mehmood')
            .update({'latitude': dlatitude, 'longitude': dlongitude});
      }

      if (userName == 'Syed Ghafran Haider') {
        await database
            .ref('Syed_Ghafran_Haider')
            .update({'latitude': dlatitude, 'longitude': dlongitude});
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<void> changeHelmetStatus(bool value, String userName) async {
    try {
      if (userName == 'Zahid Mehmood') {
        _currentUser.workerHelmetStatus = value;

        notifyListeners();

        await database.ref('Zahid_Mehmood').update({'helmetStatus': value});
      }

      if (userName == 'Syed Ghafran Haider') {
        _currentUser.workerHelmetStatus = value;

        notifyListeners();

        await database
            .ref('Syed_Ghafran_Haider')
            .update({'helmetStatus': value});
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }

  Future<Position> getCurrentLocationCordinates() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission are denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> logOut(bool isFromWorker) async {
    if (isFromWorker) {
      try {
        await auth.signOut();

        if (_currentUser.workerName == 'Zahid Mehmood') {
          await database.ref('Zahid_Mehmood').update({"n1": "0"});
        } else if (_currentUser.workerName == 'Syed Ghafran Haider') {
          await database.ref('Syed_Ghafran_Haider').update({"n2": "0"});
        }
      } on FirebaseException catch (e) {
        throw e.message!;
      }
    }
  }
}
