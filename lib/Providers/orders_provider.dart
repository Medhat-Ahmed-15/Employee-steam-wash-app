import 'dart:async';
import 'dart:convert';
import 'package:employee_steam_wash_app/models/UserInfo.dart';
import 'package:employee_steam_wash_app/models/auth_http_exception.dart';
import 'package:employee_steam_wash_app/models/finishedOrderInfo.dart';
import 'package:employee_steam_wash_app/models/orderInfo.dart';
import 'package:employee_steam_wash_app/models/orders_http_exception%20copy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderInfo> dayOrdersList = [];
  List<OrderInfo> upComingOrdersList = [];
  List<FinishedOrderInfo> finishedOrdersList = [];

  String token;

  OrdersProvider(
      {this.token,
      this.dayOrdersList,
      this.upComingOrdersList,
      this.finishedOrdersList});
  ////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  Future<void> fetchDayOrders() async {
    String url = 'https://www.car-spa.io/api/employees/orders/today';

    try {
      final response =
          await http.get(url, headers: {'x-access-token': '$token'});
      final responseData = json.decode(response.body);

      if (responseData['accepted'] != true) {
        throw HttpExceptionForOrders(responseData['message']);
      }

      var ordersListOfMaps = responseData['ordersData'];

      var orders =
          (ordersListOfMaps as List).map((e) => OrderInfo.fromjson(e)).toList();

      dayOrdersList = orders;

      print(
          'single data  ${dayOrdersList[0].booktime.toString()}'); //this print is very important because form it I detect if the list is empty or not, such that if there isn't any orders in the list then this print will throw error which in tabs screen i handle this error by showing a message indicating that there isn't any orders

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
  Future<void> fetchLaterOrders() async {
    String url = 'https://www.car-spa.io/api/employees/orders/Later';

    try {
      final response = await http.get(url, headers: {'x-access-token': token});
      final responseData = json.decode(response.body);

      if (responseData['accepted'] != true) {
        throw HttpExceptionForOrders(responseData['message']);
      }

      var ordersListOfMaps = responseData['ordersData'];

      var orders =
          (ordersListOfMaps as List).map((e) => OrderInfo.fromjson(e)).toList();

      upComingOrdersList = orders;

      print(
          'single data  ${upComingOrdersList[0].booktime.toString()}'); //this print is very important because form it I detect if the list is empty or not, such that if there isn't any orders in the list then this print will throw error which in tabs screen i handle this error by showing a message indicating that there isn't any orders

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
  Future<void> fetchFinishedOrders() async {
    String url = 'https://car-spa.io/api/employees/orders/done';

    try {
      final response = await http.get(url, headers: {'x-access-token': token});
      final responseData = json.decode(response.body);

      if (responseData['accepted'] != true) {
        throw HttpExceptionForOrders(responseData['message']);
      }

      var ordersListOfMaps = responseData['ordersData'];

      var orders = (ordersListOfMaps as List)
          .map((e) => FinishedOrderInfo.fromjson(e))
          .toList();

      finishedOrdersList = orders;

      print(
          'single data  ${finishedOrdersList[0].booktime.toString()}'); //this print is very important because form it I detect if the list is empty or not, such that if there isn't any orders in the list then this print will throw error which in tabs screen i handle this error by showing a message indicating that there isn't any orders

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // void clearFinishedOrder(String orderId) {
  //   int index =
  //       finishedOrdersList.indexWhere((element) => element.id == orderId);

  //   finishedOrdersList.removeAt(index);
  //   notifyListeners();
  // }
  ////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
}
