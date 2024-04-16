import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safety_helmet/providers/wokerProvider.dart';
import 'package:safety_helmet/screens/loginScreen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  String longitude;
  String latitude;
  HomeScreen(
    this.longitude,
    this.latitude, {
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool _isHelmetOn;
  late bool _isEmergencyAlarmOn;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    final worker =
        Provider.of<WorkerProvider>(context, listen: false).getCurrentUser;
    await Provider.of<WorkerProvider>(context, listen: false)
        .changeLongitudeLatitude(
            widget.longitude, widget.latitude, worker.workerName);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    final worker =
        Provider.of<WorkerProvider>(context, listen: false).getCurrentUser;

    _isHelmetOn = worker.workerHelmetStatus;
    _isEmergencyAlarmOn = worker.workerEmergencyAlarm;

    super.initState();
  }

  void listenLiveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        widget.latitude = position.latitude.toString();
        widget.longitude = position.longitude.toString();
      });
    });
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height - AppBar().preferredSize.height;
    final worker = Provider.of<WorkerProvider>(context).getCurrentUser;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Safety Helmet",
            style: GoogleFonts.fjallaOne(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: screenSize.width,
              height: screenHeight,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration:
                        const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        spreadRadius: 3,
                      )
                    ]),
                    child: SvgPicture.asset(
                      "assets/images/safety_helmet_grey.svg",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    worker.workerName,
                    style: GoogleFonts.fjallaOne(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 50,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Emergency Alarm",
                          style: GoogleFonts.fjallaOne(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Switch(
                          activeColor: Colors.red,
                          value: _isEmergencyAlarmOn,
                          onChanged: (value) async {
                            setState(() {
                              _isEmergencyAlarmOn = value;
                            });
                            await Provider.of<WorkerProvider>(context,
                                    listen: false)
                                .changeEmergencyAlarmStatus(
                                    value, worker.workerName);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 50,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Your Status",
                          style: GoogleFonts.fjallaOne(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          worker.workerStatus ? 'Active' : 'InActive',
                          style: GoogleFonts.fjallaOne(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 50,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Helmet Status",
                          style: GoogleFonts.fjallaOne(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Switch(
                          activeColor: Colors.green,
                          value: _isHelmetOn,
                          onChanged: (value) async {
                            setState(() {
                              _isHelmetOn = value;
                            });
                            await Provider.of<WorkerProvider>(context,
                                    listen: false)
                                .changeHelmetStatus(value, worker.workerName);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 50,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Longitude",
                          style: GoogleFonts.fjallaOne(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          widget.longitude,
                          style: GoogleFonts.fjallaOne(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    height: 50,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Latitude",
                          style: GoogleFonts.fjallaOne(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Text(
                          widget.latitude,
                          style: GoogleFonts.fjallaOne(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.map_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'On Map',
                        style: GoogleFonts.fjallaOne(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      onPressed: () {
                        double dbLongitude = double.tryParse(widget.longitude)!;
                        double dbLatitude = double.tryParse(widget.latitude)!;
                        openMap(dbLongitude, dbLatitude);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      child: !_isLoading
                          ? Text(
                              'Log Out',
                              style: GoogleFonts.fjallaOne(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            )
                          : const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                      onPressed: () async {
                        try {
                          setState(() {
                            _isLoading = !_isLoading;
                          });
                          await Provider.of<WorkerProvider>(context,
                                  listen: false)
                              .logOut(true);
                          setState(() {
                            _isLoading = !_isLoading;
                          });
                          Get.off(() => const LoginScreen());
                        } catch (e) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                                style:
                                    GoogleFonts.fjallaOne(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
