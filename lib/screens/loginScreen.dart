import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safety_helmet/providers/wokerProvider.dart';
import 'package:safety_helmet/screens/AdminHomeScreen.dart';
import 'package:safety_helmet/screens/HomeScreen.dart';
import 'package:safety_helmet/screens/SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String longitude = '';
  String latitude = '';

  Future<void> getWorkerLocation() async {
    final database = FirebaseDatabase.instance;
    final location = await Provider.of<WorkerProvider>(context, listen: false)
        .getCurrentLocationCordinates();

    longitude = location.longitude.toString();
    latitude = location.latitude.toString();
  }

  @override
  void initState() {
    getWorkerLocation();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPrivate = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: SvgPicture.asset(
                      "assets/images/safety_helmet.svg",
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      "Mining Worker Safety Helmet",
                      style: GoogleFonts.fjallaOne(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Colors.grey.shade800,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.15),
                    child: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: GoogleFonts.fjallaOne(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  color: Colors.grey.shade800,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: _email,
                              style: GoogleFonts.fjallaOne(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide: BorderSide(
                                        color: Colors.green.shade700)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                labelText: 'Your Email',
                                hintText: 'abc@gmail.com',
                                hintStyle: GoogleFonts.fjallaOne(
                                    color: const Color.fromARGB(
                                        255, 145, 145, 145),
                                    fontSize: 14),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                if (!value.contains('@')) {
                                  return 'Kindly add (@) at proper place';
                                }
                                if (value.contains('gmail') &&
                                    !value.contains('itailor')) return null;
                                if (!value.contains('gmail') &&
                                    value.contains('itailor')) return null;
                                if (!value.contains('gmail') ||
                                    !value.contains('itailor')) {
                                  return 'Invalid User Email Address.';
                                }
                                if (!value.endsWith('.com')) {
                                  return 'Invalid email address';
                                }
                                if (value.startsWith(RegExp(r'[0-9]'))) {
                                  return 'Email cannot start with a number';
                                }

                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: _password,
                              obscureText: _isPrivate ? true : false,
                              style: GoogleFonts.fjallaOne(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              focusNode: _passwordFocusNode,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide: BorderSide(
                                        color: Colors.green.shade700)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                labelText: 'Password',
                                hintText: 'abc@123',
                                hintStyle: GoogleFonts.fjallaOne(
                                    color: const Color.fromARGB(
                                        255, 145, 145, 145),
                                    fontSize: 14),
                                suffix: IconButton(
                                  icon: Icon(
                                    _isPrivate
                                        ? Icons.remove_red_eye_outlined
                                        : Icons.shield_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPrivate = !_isPrivate;
                                    });
                                  },
                                ),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'Password should consist at least 6 characters';
                                }
                                if (value.contains('~') ||
                                    value.contains('*') ||
                                    value.contains('&') ||
                                    value.contains('#')) {
                                  return 'Invalid Password';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      child: !_isLoading
                          ? Text(
                              "Login",
                              style: GoogleFonts.fjallaOne(
                                  color: Colors.white, fontSize: 16),
                            )
                          : const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_email.text == 'hashim@gmail.com' &&
                              _password.text == '12345678') {
                            Get.off(() => const AdminHomeScreen());
                          } else {
                            setState(() {
                              _isLoading = !_isLoading;
                            });

                            try {
                              await Provider.of<WorkerProvider>(context,
                                      listen: false)
                                  .login(_email.text.trim(),
                                      _password.text.trim());
                              setState(() {
                                _isLoading = !_isLoading;
                              });
                              Get.off(() => HomeScreen(
                                    longitude,
                                    latitude,
                                  ));
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  e.toString(),
                                  style: GoogleFonts.fjallaOne(
                                      color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 5),
                              ));
                            }
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.fjallaOne(
                          color: Colors.green, fontSize: 16),
                    ),
                    onPressed: () {
                      Get.off(() => const SignUpScreen());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
