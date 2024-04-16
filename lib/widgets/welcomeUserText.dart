import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safety_helmet/widgets/workersNodeListWidget.dart';

class WelcomeUserTextWidget extends StatelessWidget {
  const WelcomeUserTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Muhammad Hashim',
            style: GoogleFonts.fjallaOne(
                fontSize: 26.0,
                letterSpacing: 2.0,
                color: Colors.green.shade900,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            'Welcome',
            style: GoogleFonts.fjallaOne(
              fontSize: 18.0,
              letterSpacing: 2.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
