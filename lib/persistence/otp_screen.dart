import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testdemo/persistence/home_screen.dart';

class OtpScreen extends StatefulWidget {
  String mobile;

  OtpScreen(this.mobile, {super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _verificationId = "";
  String _code = "";
  String? varificationCode;
  String _token = "";

  bool _isLoading = false;

  OtpFieldController otpController = OtpFieldController();

  @override
  void initState() {
    setState(() {
      phoneSignIn(
        phoneNumber: widget.mobile,
      );
      verifyPhoneNumber();
      setState(() {
        _isLoading = true;
      });
    });

    super.initState();
  }

  void verifyOtp() {
    if (_code.length != 5) {
      setState(() {
        _isLoading = false;
      });
      setState(() {
        Fluttertoast.showToast(
          msg: 'OTP Verify Successfully..',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        _isLoading = false;
      });

      try {
        setState(() {
          FirebaseAuth _auth = FirebaseAuth.instance;
          final AuthCredential credential = PhoneAuthProvider.credential(
              verificationId: _verificationId, smsCode: _code);
          print("************");

          print(_auth);
          print(_code);
          print(_verificationId);
          // print("VERIFY==>"+credential.token.toString());
          _auth.signInWithCredential(credential).then((value) {
            print("PASS==>" + value.toString());
            setState(() {
              Fluttertoast.showToast(
                msg: 'OTP Verify Successfully..',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: const HomeScreen()));
              _isLoading = false;
            });
          }, onError: (error) {
            setState(() {
              _isLoading = false;
            });
            print("ERROR==>" + error.toString());
            Fluttertoast.showToast(
              msg: 'Session Expire Please Resend OTP..',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          });
        });

        // showCustomToast("===>VERIFY==>"+credential.signInMethod.toString());
      } catch (e) {
        Fluttertoast.showToast(
          msg: "EXCEPTION==>" + e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // showCustomToast("EXCEPTION==>" + e.toString());
      }
    } else {
      Navigator.of(context);
      // .push(MaterialPageRoute(builder: (context) => CityPage()));
      Fluttertoast.showToast(
        msg: "Please Enter OTP",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // showCustomToast("Please Enter OTP");
    }
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    setState(() {
      _isLoading = true;
    });
    FirebaseAuth _auth = await FirebaseAuth.instance;
    setState(() {
      _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout,
        verificationFailed: _onVerificationFailed,
        verificationCompleted: _onVerificationCompleted,
      );
    });

    print(phoneNumber);
    print(_verificationId);
  }

  verifyPhoneNumber() async {
    // var _code;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${"+91" + widget.mobile}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          if (value.user != null) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => const HomeScreen()));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      codeSent: (String vID, int? resendToken) {
        setState(() {
          varificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          varificationCode = vID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    FirebaseAuth _auth = await FirebaseAuth.instance;
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;

    setState(() {
      _code = authCredential.smsCode!;

      // Navigator.push(
      //   context,
      //   PageTransition(
      //     type: PageTransitionType.fade,
      //     child: RootPage(),
      //   ),
      // );
    });
    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
            await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }

      // setState(() {
      //   isLoading = false;
      // });
      // Navigator.pushNamedAndRemoveUntil(
      //     context, Constants.homeNavigate, (route) => false);
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    setState(() {
      print("====>ERROR==>" + exception.message!);

      if (exception.code == 'invalid-phone-number') {
        Fluttertoast.showToast(
          msg: "The phone number entered is invalid!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // showCustomToast("The phone number entered is invalid!");
      }
    });
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    _verificationId = verificationId;
    print(forceResendingToken);
    Fluttertoast.showToast(
      msg: "code sent on registered mobile number",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    // showCustomToast("code sent on registered mobile number");
    setState(() {
      _isLoading = false;
    });
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  // void verifyOtp() {
  //   if (_code.length != 5) {
  //     print("Function Is Calling In Verify Otp");
  //     print(_code);

  //     try {
  //       setState(() {
  //         FirebaseAuth _auth = FirebaseAuth.instance;
  //         final AuthCredential credential = PhoneAuthProvider.credential(
  //             verificationId: _verificationId, smsCode: _code);
  //         print("************");

  //         print(_auth);
  //         print(_code);
  //         print(_verificationId);
  //         // print("VERIFY==>"+credential.token.toString());
  //         _auth.signInWithCredential(credential).then((value) {
  //           print("PASS==>" + value.toString());
  //           setState(() {
  //             Fluttertoast.showToast(
  //               msg: 'OTP Verify Successfully..',
  //               toastLength: Toast.LENGTH_SHORT,
  //               timeInSecForIosWeb: 1,
  //               backgroundColor: Colors.black,
  //               textColor: Colors.white,
  //               fontSize: 16.0,
  //             );
  //             callApi();

  //             // Navigator.push(
  //             //     context,
  //             //     PageTransition(
  //             //         type: PageTransitionType.fade, child: const RootPage()));
  //             _isLoading = false;
  //           });
  //         }, onError: (error) {
  //           setState(() {
  //             _isLoading = false;
  //           });
  //           print("ERROR ==>" + error.toString());

  //           Fluttertoast.showToast(
  //             msg: 'Session Expire Please Resend OTP..',
  //             toastLength: Toast.LENGTH_SHORT,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.black,
  //             textColor: Colors.white,
  //             fontSize: 16.0,
  //           );
  //         });
  //       });

  //       // showCustomToast("===>VERIFY==>"+credential.signInMethod.toString());
  //     } catch (e) {
  //       print("In Catch????");
  //       setState(() {
  //         Fluttertoast.showToast(
  //           msg: "EXCEPTION==>" + e.toString(),
  //           toastLength: Toast.LENGTH_SHORT,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //       });

  //       // showCustomToast("EXCEPTION==>" + e.toString());
  //     }
  //   } else {
  //     setState(() {
  //       print("Kucch To Gadbad He ");

  //       // Navigator.of(context);
  //       // .push(MaterialPageRoute(builder: (context) => CityPage()));
  //       Fluttertoast.showToast(
  //         msg: "Please Enter OTP",
  //         toastLength: Toast.LENGTH_SHORT,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     });

  //     // showCustomToast("Please Enter OTP");
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Otp Verification',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: h * 0.04),
              ),
              SizedBox(
                height: h * 0.045,
              ),
              const Text(
                "We Will send you a one time password on",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "this ",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  const Text(
                    "Mobile No",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.045,
              ),
              Text(
                "+91" + " ${widget.mobile}",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(
                height: h * 0.07,
              ),
              SizedBox(
                height: h * 0.05,
                child: OTPTextField(
                  spaceBetween: 10,
                  keyboardType: TextInputType.number,
                  controller: otpController,
                  length: 6,
                  width: w * 1,
                  textFieldAlignment: MainAxisAlignment.center,
                  fieldWidth: w * 0.10,
                  otpFieldStyle: OtpFieldStyle(
                    enabledBorderColor: const Color.fromARGB(255, 111, 192, 128)
                        .withOpacity(0.1),
                    focusBorderColor: const Color.fromARGB(255, 111, 192, 128)
                        .withOpacity(0.1),
                    backgroundColor: const Color.fromARGB(255, 111, 192, 128),
                  ),
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 45,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  onChanged: (pin) {
                    print("Changed: " + pin);
                  },
                  onCompleted: (pin) {
                    setState(
                      () {
                        _code = pin;

                        print("Final Otp Is " + _code);
                        print("Verification Code is" +
                            varificationCode.toString());
                        verifyOtp();
                      },
                    );

                    print("Completed: " + pin);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
