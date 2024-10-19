// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_maker/HELPER/asset_helper.dart';
import 'package:money_maker/PROVIDERS/login_auth_provider.dart';
import 'package:money_maker/PROVIDERS/policy_status_pvovider.dart';
import 'package:money_maker/SCREENS/home_screen.dart';
import 'package:money_maker/THEMES/app_theme.dart';
import 'package:money_maker/WIDGETS/BUTTONS/auth_button.dart';
import 'package:money_maker/WIDGETS/login_helpers.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Future<bool?> getFieldData() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill  all required fields for signing in");
      return false; // or return null;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    final authProvider = Provider.of<LoginAuthProvider>(context);
    return Scaffold(
      // backgroundColor: Colors.yellow[500],
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.lightBlue,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 15),
                child: Text(
                  'Login Here',
                  style: TextStyle(
                    fontSize: size.width * 0.12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monuse',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    width: size.width,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueGrey.withOpacity(.3),
                          Colors.blueGrey.withOpacity(.3),
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Keep it minimal
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Email',
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ),
                              TextFieldContainer(
                                widget: CustomTextField(
                                  textInputType: TextInputType.emailAddress,
                                  hintText: 'Enter your email',
                                  prefixIcon: Icons.mail_outline_rounded,
                                  isObscure: false,
                                  showSuffix: false,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Password',
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ),
                              TextFieldContainer(
                                widget: CustomTextField(
                                  textInputType: TextInputType.visiblePassword,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock_outline_rounded,
                                  isObscure: true,
                                  showSuffix: true,
                                  textInputAction: TextInputAction.done,
                                  textEditingController: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length < 6) {
                                      return 'Password must be greater than 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        AuthenticationButton(onTap: () {}, text: "Login"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.white,
                                height: 1,
                              )),
                              const Text('Or'),
                              Expanded(
                                  child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: Colors.white,
                                height: 1,
                              )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer<PolicyStatusProvider>(
                            builder: (context, status, child) {
                              return Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      status.toggleStatus();
                                    },
                                    icon: Icon(
                                      status.accepted
                                          ? Icons.check_box_rounded
                                          : Icons
                                              .check_box_outline_blank_rounded,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: "By continuing you accept our ",
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w200,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print("navigate to web");
                                              },
                                          ),
                                          const TextSpan(
                                            text: " and ",
                                          ),
                                          TextSpan(
                                            text: "terms of use",
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print("navigate to web");
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            showGLoading();
                            try {
                              await authProvider.googleSignIn(context);
                            } catch (e) {
                              log(e.toString());
                            } finally {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: size.height * .06,
                            width: size.width * .85,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  GetAssetFile.googleIcon,
                                  width: 35,
                                  height: 35,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Google Signing",
                                  style: PerfectTeme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showGLoading() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Logging in...'),
            ],
          ),
        );
      },
    );
  }
}

Future<void> navigateTO(BuildContext context, bool status) {
  if(status){
   return Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }else{
  return  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
