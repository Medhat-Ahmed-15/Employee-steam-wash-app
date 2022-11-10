// ignore_for_file: file_names

import 'dart:convert';

import 'package:employee_steam_wash_app/models/finishedOrderInfo.dart';
import 'package:employee_steam_wash_app/models/orderInfo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralMethods {
  static void show_toast(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey[500],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  //******************************************************************** */

  static void show_dialog(String errorMessage, BuildContext context) {
    showDialog(
      barrierColor: Colors.white10,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[300],
        title: const Text('An Error Occurred!'),
        titleTextStyle: TextStyle(color: Colors.red),
        content: Text(
          errorMessage,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay',
                  style: TextStyle(color: Theme.of(context).primaryColor)))
        ],
      ),
    );
  }
  //******************************************************************** */

  static String convertDateToDayInNumberMonthInText(OrderInfo orderInfo) {
    String monthInText;
    String dayInNumber;

    dayInNumber = orderInfo.orderdate.split('T')[0].split('-')[2];

    if (dayInNumber.split('')[0].contains('0')) {
      dayInNumber =
          orderInfo.orderdate.split('T')[0].split('-')[2].split('')[1];
    }

    int month = int.parse(orderInfo.orderdate.split('T')[0].split('-')[1]);

    if (month == 1) {
      monthInText = 'Jan';
    } else if (month == 2) {
      monthInText = 'Feb';
    } else if (month == 3) {
      monthInText = 'Mar';
    } else if (month == 4) {
      monthInText = 'Apr';
    } else if (month == 5) {
      monthInText = 'May ';
    } else if (month == 6) {
      monthInText = 'Jun';
    } else if (month == 7) {
      monthInText = 'Jul';
    } else if (month == 8) {
      monthInText = 'Aug';
    } else if (month == 9) {
      monthInText = 'Sep';
    } else if (month == 10) {
      monthInText = 'Oct';
    } else if (month == 11) {
      monthInText = 'Nov';
    } else if (month == 12) {
      monthInText = 'Dec';
    }

    String ordderDate = dayInNumber + " " + monthInText;

    return ordderDate;
  }

  //******************************************************************** */

  static String convertTimeTo12HFormat(OrderInfo orderInfo) {
    String time = orderInfo.booktime;
    String covertedTime;

    TimeOfDay timeOfDay = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));

    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();

    return format.format(dt);
  }

  //******************************************************************** */

  //******************************************************************** */

  static String convertDateToDayInNumberMonthInTextForFinishedOrders(
      FinishedOrderInfo orderInfo) {
    String monthInText;
    String dayInNumber;

    dayInNumber = orderInfo.orderdate.split('T')[0].split('-')[2];

    if (dayInNumber.split('')[0].contains('0')) {
      dayInNumber =
          orderInfo.orderdate.split('T')[0].split('-')[2].split('')[1];
    }

    int month = int.parse(orderInfo.orderdate.split('T')[0].split('-')[1]);

    if (month == 1) {
      monthInText = 'Jan';
    } else if (month == 2) {
      monthInText = 'Feb';
    } else if (month == 3) {
      monthInText = 'Mar';
    } else if (month == 4) {
      monthInText = 'Apr';
    } else if (month == 5) {
      monthInText = 'May ';
    } else if (month == 6) {
      monthInText = 'Jun';
    } else if (month == 7) {
      monthInText = 'Jul';
    } else if (month == 8) {
      monthInText = 'Aug';
    } else if (month == 9) {
      monthInText = 'Sep';
    } else if (month == 10) {
      monthInText = 'Oct';
    } else if (month == 11) {
      monthInText = 'Nov';
    } else if (month == 12) {
      monthInText = 'Dec';
    }

    String ordderDate = dayInNumber + " " + monthInText;

    return ordderDate;
  }

  //******************************************************************** */

  static String convertTimeTo12HFormatForFinishedOrders(
      FinishedOrderInfo orderInfo) {
    String time = orderInfo.booktime;
    String covertedTime;

    TimeOfDay timeOfDay = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));

    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm();

    return format.format(dt);
  }

  //******************************************************************** */

  static Future<void> setEmployeeStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();

    final employeeCurrentStatus = json.encode({
      'status': status,
    });

    prefs
        .setString('employeeCurrentStatus', employeeCurrentStatus)
        .then((value) => print('Storage response: $value'));
  }

  //******************************************************************** */

  static Future<String> getEmployeeStatus() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('employeeCurrentStatus')) {
      final extractedEmployee =
          json.decode(prefs.getString('employeeCurrentStatus'))
              as Map<String, Object>;

      return extractedEmployee['status'];
    } else {
      return 'error';
    }
  }

  //******************************************************************** */

  static Future<void> setPickedOrder(OrderInfo pickedOrder) async {
    final prefs = await SharedPreferences.getInstance();

    final inProgressOrder = json.encode({
      'customername': pickedOrder.customername,
      'customerphonenumber': pickedOrder.customerphonenumber,
      'orderdate': pickedOrder.orderdate,
      'booktime': pickedOrder.booktime,
      'servicename': pickedOrder.servicename,
      'longitude': pickedOrder.longitude,
      'latitude': pickedOrder.latitude,
      'locationname': pickedOrder.locationname,
      'price': pickedOrder.price,
    });

    prefs
        .setString('pickedOrder', inProgressOrder)
        .then((value) => print('Storage response: $value'));
  }

  //******************************************************************** */

  static Future<OrderInfo> getPickedOrder() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('pickedOrder')) {
      final extractedPickedOrder =
          json.decode(prefs.getString('pickedOrder')) as Map<String, dynamic>;

      OrderInfo pickedOrder = OrderInfo();
      pickedOrder.customername = extractedPickedOrder['customername'];
      pickedOrder.customerphonenumber =
          extractedPickedOrder['customerphonenumber'];
      pickedOrder.orderdate = extractedPickedOrder['orderdate'];
      pickedOrder.booktime = extractedPickedOrder['booktime'];
      pickedOrder.servicename = extractedPickedOrder['servicename'];
      pickedOrder.longitude = extractedPickedOrder['longitude'];
      pickedOrder.latitude = extractedPickedOrder['latitude'];
      pickedOrder.locationname = extractedPickedOrder['locationname'];
      pickedOrder.price = extractedPickedOrder['price'];

      return pickedOrder;
    } else {
      return null;
    }
  }

  static Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final inProgressOrder = json.encode({
      'customername': null,
      'customerphonenumber': null,
      'orderdate': null,
      'booktime': null,
      'servicename': null,
      'longitude': null,
      'latitude': null,
      'locationname': null,
      'price': null,
    });

    prefs
        .setString('pickedOrder', inProgressOrder)
        .then((value) => print('Storage Emptiness: $value'));

    final employeeCurrentStatus = json.encode({
      'status': null,
    });

    prefs
        .setString('employeeCurrentStatus', employeeCurrentStatus)
        .then((value) => print('Storage Emptiness: $value'));
  }
}
