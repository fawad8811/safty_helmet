import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safety_helmet/screens/loginScreen.dart';
import 'package:safety_helmet/widgets/controller.dart';
import 'package:safety_helmet/widgets/welcomeUserText.dart';
import 'package:safety_helmet/widgets/workersNodeListWidget.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final UIController c = Get.put(UIController());
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Safety Helmet",
            style: GoogleFonts.fjallaOne(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
                size: 20.0,
              ),
              onPressed: () => Get.to(() => const LoginScreen()),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            width: screenSize.width,
            height: screenSize.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WelcomeUserTextWidget(),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Your workers nodes list:',
                  style: GoogleFonts.fjallaOne(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                const Expanded(flex: 1, child: WorkersNodeWidgetListWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
