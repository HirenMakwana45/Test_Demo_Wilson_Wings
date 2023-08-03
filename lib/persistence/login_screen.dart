import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testdemo/core/utils/image_constant.dart';
import 'package:testdemo/persistence/otp_screen.dart';
import 'package:testdemo/widgets/custom_image_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController Mobilectrl = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _token = "";

  void initState() {
    getToken();

    super.initState();
  }

  //This Function For Read Token For authentication
  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _token = value.toString();
      print("===>TOKEN==>" + token.toString());
    });
  }

  void initApp() async {
    await Firebase.initializeApp().whenComplete(
      () {
        print("===>COMPLETE=>" + Firebase.app().name.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // two variable for responsive design
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              right: 16,
              left: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  radius: BorderRadius.circular(120),
                  margin: EdgeInsets.only(top: h * 0.1, bottom: h * 0.05),
                  imagePath: ImageConstant.imglogo,
                ),
                Text(
                  'Wilson Wings',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: h * 0.05),
                ),
                SizedBox(
                  height: h * 0.015,
                ),
                Text(
                  'Sign in to your account',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: const Color.fromARGB(255, 202, 200, 200),
                      fontSize: h * 0.02),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                SizedBox(
                  height: h * 0.087,
                  child: TextFormField(
                    style: TextStyle(color: Color.fromARGB(255, 111, 192, 128)),
                    cursorColor: Color.fromARGB(255, 111, 192, 128),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: Mobilectrl,
                    validator: (val) {
                      if (!validation(val!).isValidPhone) {
                        return 'Please Enter valid Mobile';
                      }
                    },
                    maxLength: 10,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      errorStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7)),
                      labelText: 'Mobile Number',
                      labelStyle: const TextStyle(
                          color: Color(0xffC1C1C1), fontSize: 13),
                      floatingLabelStyle: const TextStyle(
                          color: Color.fromARGB(255, 111, 192, 128)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 111, 192, 128),
                        ),
                      ),
                      helperStyle: const TextStyle(
                        color: Color.fromARGB(255, 111, 192, 128),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.1,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(w * 0.75, h * 0.06),
                      // minimumSize: Size(w * 0.05, h * 0.06),
                      backgroundColor: const Color.fromARGB(255, 111, 192, 128),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: OtpScreen(Mobilectrl.text.toString()),
                            ),
                          );
                          print("Pressed");
                        });
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign in',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: h * 0.029),
                      ),
                      SizedBox(
                        width: w * 0.04,
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: h * 0.035,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Validation Class
extension validation on String {
  bool get isValidPhone {
    final phoneRegExp = RegExp(r"[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}
