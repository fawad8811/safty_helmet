import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safety_helmet/providers/adminWorkersProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibration/vibration.dart';

class WorkersNodeWidgetListWidget extends StatefulWidget {
  const WorkersNodeWidgetListWidget({Key? key}) : super(key: key);

  @override
  State<WorkersNodeWidgetListWidget> createState() =>
      _WorkersNodeWidgetListWidgetState();
}

class _WorkersNodeWidgetListWidgetState
    extends State<WorkersNodeWidgetListWidget> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    await Provider.of<AdminWorkersProvider>(context, listen: false)
        .fetchAllWorkers();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final workerList =
        Provider.of<AdminWorkersProvider>(context, listen: true).getWorkersList;
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
        itemCount: workerList.length,
        itemBuilder: (context, index) {
          return WorkersNodeWidget(
            nodeIndex: index,
            workerId: workerList[index].workerId,
            workerName: workerList[index].workerName,
            wokerStatus: workerList[index].workerStatus,
            workerHelmetStatus: workerList[index].workerHelmetStatus,
            workerEmergencyAlarm: workerList[index].workerEmergencyAlarm,
            workerLatitude: workerList[index].workerLatitude,
            workerLongitude: workerList[index].workerLongitude,
            screenSize: screenSize,
          );
        },
      ),
    );
  }
}

class WorkersNodeWidget extends StatefulWidget {
  final int nodeIndex;
  final String workerId;
  final String workerName;
  final bool wokerStatus;
  final bool workerHelmetStatus;
  final double? workerLongitude;
  final double? workerLatitude;
  bool workerEmergencyAlarm;
  final Size screenSize;

  WorkersNodeWidget(
      {Key? key,
      required this.nodeIndex,
      required this.workerId,
      required this.wokerStatus,
      required this.workerName,
      required this.workerHelmetStatus,
      required this.workerEmergencyAlarm,
      required this.workerLatitude,
      required this.workerLongitude,
      required this.screenSize})
      : super(key: key);

  @override
  State<WorkersNodeWidget> createState() => _WorkersNodeWidgetState();
}

class _WorkersNodeWidgetState extends State<WorkersNodeWidget> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  late double containerHeight;
  late double containerDefaultHeight;
  late double extendedContainerHeight;
  bool setVibrator = false;

  @override
  void initState() {
    extendedContainerHeight = widget.screenSize.height * 0.45;
    containerDefaultHeight = widget.screenSize.height * 0.09;
    containerHeight = containerDefaultHeight;

    database.ref('Zahid_Mehmood').onValue.listen((event) {
      final fire1Value = event.snapshot.child('fire1').value.toString();
      final gas1Value = event.snapshot.child('gas1').value.toString();

      var isEmergency = fire1Value == '1' && gas1Value == '1' ? true : false;

      if (isEmergency) {
        setVibratorOnOff();
      }
    });

    database.ref('Syed_Ghafran_Haider').onValue.listen((event) {
      final fire2Value = event.snapshot.child('fire2').value.toString();
      final gas2Value = event.snapshot.child('gas2').value.toString();

      var isEmergency = fire2Value == '1' && gas2Value == '1' ? true : false;

      if (isEmergency) {
        setVibratorOnOff();
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    setVibratorOnOff();
    super.didChangeDependencies();
  }

  void openMap(double longitude, double latitude) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      await canLaunchUrlString(googleURL)
          ? await launchUrlString(googleURL)
          : throw 'Could not launch $googleURL';
    } catch (e) {
      throw e.toString();
    }
  }

  void setVibratorOnOff() async {
    if (setVibrator || widget.workerEmergencyAlarm) {
      bool? hasVibrator = await Vibration.hasVibrator();

      if (hasVibrator != null && hasVibrator) {
        await Vibration.vibrate(duration: 3000, repeat: 3);
      }
    } else {
      await Vibration.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (containerHeight == extendedContainerHeight) {
          setState(() {
            containerHeight = containerDefaultHeight;
          });
        } else {
          setState(() {
            containerHeight = extendedContainerHeight;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 0),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
        height: containerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10.0,
                spreadRadius: 3.0,
              )
            ],
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.green.shade700,
                Colors.green.shade900,
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    "assets/images/safety_helmet.svg",
                    width: 25,
                    height: 25,
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Text(
                  'Worker Node ${widget.nodeIndex}',
                  style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  onPressed: () {
                    if (containerHeight == extendedContainerHeight) {
                      setState(() {
                        containerHeight = containerDefaultHeight;
                      });
                    } else {
                      setState(() {
                        containerHeight = extendedContainerHeight;
                      });
                    }
                  },
                ),
              ],
            ),
            if (containerHeight == extendedContainerHeight)
              const Divider(
                color: Colors.white,
                thickness: 1.0,
              ),
            if (containerHeight == extendedContainerHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name:',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.workerName,
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (containerHeight == extendedContainerHeight)
              const SizedBox(
                height: 5.0,
              ),
            if (containerHeight == extendedContainerHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Worker Status:',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.wokerStatus ? 'Active' : 'InActive',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (containerHeight == extendedContainerHeight)
              const SizedBox(
                height: 5.0,
              ),
            if (containerHeight == extendedContainerHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Helmet Status:',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.workerHelmetStatus ? 'ON' : 'OFF',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (containerHeight == extendedContainerHeight)
              const SizedBox(
                height: 5.0,
              ),
            if (containerHeight == extendedContainerHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Longitude:',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.workerLongitude.toString(),
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (containerHeight == extendedContainerHeight)
              const SizedBox(
                height: 5.0,
              ),
            if (containerHeight == extendedContainerHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'latitude:',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.workerLatitude.toString(),
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            if (containerHeight == extendedContainerHeight)
              const SizedBox(
                height: 5.0,
              ),
            if (containerHeight == extendedContainerHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Emergency Alarm:',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                    ),
                  ),
                  // Text(widget.workerEmergencyAlarm ? 'ON' : 'OFF', style: GoogleFonts.fjallaOne(color: Colors.white, ),),
                  Switch(
                    activeColor: Colors.green,
                    value: widget.workerEmergencyAlarm,
                    onChanged: (value) async {
                      await Provider.of<AdminWorkersProvider>(context,
                              listen: false)
                          .changeEmergencyAlarmStatus(value, widget.workerName);
                      setState(() {
                        setVibrator = !setVibrator;
                        setVibratorOnOff();
                      });
                    },
                  ),
                ],
              ),
            if (containerHeight == extendedContainerHeight) const Spacer(),
            if (containerHeight == extendedContainerHeight)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      label: Text(
                        'Map',
                        style:
                            GoogleFonts.fjallaOne(color: Colors.green.shade900),
                      ),
                      icon: Icon(
                        Icons.map_outlined,
                        color: Colors.green.shade900,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () {
                        try {
                          openMap(
                              widget.workerLongitude!, widget.workerLatitude!);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Opps!',
                                style: GoogleFonts.quicksand(
                                    fontSize: 26.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                e.toString(),
                                style: GoogleFonts.quicksand(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.left,
                              ),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'Ok',
                                    style: GoogleFonts.quicksand(
                                      color:
                                          const Color.fromRGBO(61, 130, 241, 1),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
