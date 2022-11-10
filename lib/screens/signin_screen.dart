import 'package:employee_steam_wash_app/Assistants/general_methods.dart';
import 'package:employee_steam_wash_app/Providers/auth_provider.dart';
import 'package:employee_steam_wash_app/models/auth_http_exception.dart';
import 'package:employee_steam_wash_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  static final routName = '/SigninScreen';
  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  String errorMessage;

  Color phoneBorderColor = Colors.grey[300];
  Color phoneFillColor = Colors.grey[300];
  Color phoneIconColor = Colors.grey[600];
  Color phoneInputTextColor = Colors.black;

  Color passwordBorderColor = Colors.grey[300];
  Color passwordFillColor = Colors.grey[300];
  Color passwordIconColor = Colors.grey[600];
  Color passwordInputTextColor = Colors.black;
  Color eyeColor = Colors.grey[600];

  bool loading = false;
  bool showErrorText = false;
  bool hidePasswordText = true;

  void sign_in(BuildContext context) async {
    setState(() {
      loading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).employeeSignin(
          _phoneNumberController.text, _passwordController.text);
    } on HttpExceptionForAuth catch (error) {
      var errorField = error.toStringField();

      if (errorField == 'phone') {
        setState(() {
          phoneBorderColor = Colors.red;
          phoneIconColor = Colors.red;
          phoneInputTextColor = Colors.red;
          showErrorText = true;
          errorMessage = error.toStringMessage();
        });
      } else if (errorField == 'password') {
        setState(() {
          passwordBorderColor = Colors.red;
          passwordIconColor = Colors.red;
          passwordInputTextColor = Colors.red;
          showErrorText = true;
          eyeColor = Colors.red;
          errorMessage = error.toStringMessage();
        });
      }

      setState(() {});
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please check your internet connection and try again later.';
      GeneralMethods.show_dialog(errorMessage, context);

      setState(() {
        loading = false;
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        // mainAxisAlignment: Main,
        children: [
          Container(
              //padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(top: 60, left: 0),
              height: 250,
              width: 250,
              child: Image.asset('assets/images/logo.png')),
          const SizedBox(
            height: 25,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 15.0,
              shadowColor: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Phone signin textfield************************************************************************************

                  Container(
                    margin: EdgeInsets.only(top: 50, left: 25, right: 30),
                    decoration: BoxDecoration(
                      color: phoneFillColor,
                      border: Border.all(
                        color: phoneBorderColor,
                        width: 1.5,
                      ),
                      // color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // width: 400,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          color: phoneIconColor,
                        ),
                        Expanded(
                          child: Container(
                            child: TextField(
                              onTap: () {
                                setState(() {
                                  phoneInputTextColor = Colors.black;
                                  phoneFillColor = Colors.white;
                                  phoneBorderColor =
                                      Theme.of(context).primaryColor;
                                  phoneIconColor =
                                      Theme.of(context).primaryColor;
                                });
                              },
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              cursorColor: Theme.of(context).primaryColor,
                              style: TextStyle(
                                color: phoneInputTextColor,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(8),
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  //password signin textfield************************************************************************************

                  Container(
                    margin: EdgeInsets.only(top: 25, left: 25, right: 30),
                    decoration: BoxDecoration(
                      color: passwordFillColor,
                      border: Border.all(
                        color: passwordBorderColor,
                        width: 1.5,
                      ),
                      // color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: passwordIconColor,
                        ),
                        Expanded(
                          child: Container(
                            child: TextField(
                              onTap: () {
                                setState(() {
                                  passwordInputTextColor = Colors.black;
                                  passwordFillColor = Colors.white;
                                  passwordBorderColor =
                                      Theme.of(context).primaryColor;
                                  passwordIconColor =
                                      Theme.of(context).primaryColor;
                                });
                              },
                              controller: _passwordController,
                              obscureText: hidePasswordText,
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).primaryColor,
                              style: TextStyle(
                                color: passwordInputTextColor,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(8),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                bool prevHidePasswordText = hidePasswordText;
                                hidePasswordText = !prevHidePasswordText;
                              });
                            },
                            child: Icon(
                              Icons.remove_red_eye_outlined,
                              color: passwordIconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //error text
                  showErrorText == true
                      ? Container(
                          margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                          child: Text(
                            '❗$errorMessage',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 15),
                          ),
                        )
                      : SizedBox(height: 0),

                  //signin button************************************************************************************

                  FlatButton(
                    child: Container(
                      margin: EdgeInsets.only(top: 50, left: 25, right: 30),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 50,
                      width: 400,
                      child: Align(
                        alignment: Alignment.center,
                        child: loading == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    onPressed: () {
                      sign_in(context);
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
