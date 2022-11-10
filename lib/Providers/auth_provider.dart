import 'dart:async';
import 'dart:convert';
import 'package:employee_steam_wash_app/global_variables.dart';
import 'package:employee_steam_wash_app/models/UserInfo.dart';
import 'package:employee_steam_wash_app/models/auth_http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String user;
  Timer logOutTimer;
  UserInfo _singleUserInfo;

//Checking Authentication Function>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  bool checkauthentication() {
    if (_token != null) {
      return true;
    }
    return false;
  }

  //Function for getting the TOKEN,i may need the token from  somewhere else
  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

//Function for getting the Current user data,i may need the token from  somewhere else
  UserInfo get getCurrentUserData {
    return _singleUserInfo;
  }

  //Authentication User>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> employeeSignin(
    String phone,
    String password,
  ) async {
    String url =
        'https://car-spa.io/api/auth/employees/login?phone=$phone&password=$password';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);

      if (responseData['accepted'] != true) {
        throw HttpExceptionForAuth(responseData);
      }

      _token = responseData['token'];
      currentEmployeeId = responseData['employeeData']['id'];
      print('employee id from auth provider ' + currentEmployeeId);
      currentEmployeeUserName = responseData['employeeData']['username'];

      UserInfo userInfo = new UserInfo();
      userInfo.id = responseData['employeeData']['id'];
      userInfo.username = responseData['employeeData']['username'];
      userInfo.address = responseData['employeeData']['address'];
      userInfo.nationalid = responseData['employeeData']['nationalid'];
      userInfo.password = responseData['employeeData']['password'];
      userInfo.active = responseData['employeeData']['active'];
      userInfo.stillworking = responseData['employeeData']['stillworking'];
      userInfo.accountcreationdate =
          responseData['employeeData']['accountcreationdate'];
      userInfo.phonenumber = responseData['employeeData']['phonenumber'];

      _singleUserInfo = userInfo;

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        'token': _token,
        'userId': responseData['employeeData']['id'],
        'username': responseData['employeeData']['username'],
        'address': responseData['employeeData']['address'],
        'nationalid': responseData['employeeData']['nationalid'],
        'password': responseData['employeeData']['password'],
        'active': responseData['employeeData']['active'],
        'stillworking': responseData['employeeData']['stillworking'],
        'accountcreationdate': responseData['employeeData']
            ['accountcreationdate'],
        'phonenumber': responseData['employeeData']['phonenumber'],
      });

      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  //Auto Sigin>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      _token = extractedUserData['token'];
      currentEmployeeId = extractedUserData['userId'];

      UserInfo userInfo = new UserInfo();
      userInfo.id = extractedUserData['id'];
      userInfo.username = extractedUserData['username'];
      userInfo.address = extractedUserData['address'];
      userInfo.nationalid = extractedUserData['nationalid'];
      userInfo.password = extractedUserData['password'];
      userInfo.active = extractedUserData['active'];
      userInfo.stillworking = extractedUserData['stillworking'];
      userInfo.accountcreationdate = extractedUserData['accountcreationdate'];
      userInfo.phonenumber = extractedUserData['phonenumber'];

      _singleUserInfo = userInfo;

      notifyListeners();
      //_singleUserInfo = extractedUserData['currentUserData'];
      _autoSignOut();
      return true;
    } else {
      return false;
    }
  }

  //Signout Function>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> SignOut() async {
    _token = null;
    currentEmployeeId = null;

    if (logOutTimer != null) {
      logOutTimer.cancel();
      logOutTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final userData = json.encode({
      'token': null,
      'userId': null,
    });

    prefs.setString('userData', userData);
    prefs.clear();
  }

  //Auto Signout>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  void _autoSignOut() {
    if (logOutTimer != null) {
      logOutTimer.cancel();
    }

    logOutTimer = Timer(Duration(days: 30), SignOut);
  }
}
