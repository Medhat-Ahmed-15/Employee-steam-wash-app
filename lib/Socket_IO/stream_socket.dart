import 'dart:async';
import 'package:employee_steam_wash_app/screens/map_screen.dart';
import 'package:employee_steam_wash_app/screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:employee_steam_wash_app/Notifications/notifications.dart';
import 'package:employee_steam_wash_app/Providers/auth_provider.dart';
import 'package:employee_steam_wash_app/screens/maintenance_screen.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

Socket socket;

//Under maintenance  event ****************************************************************************************
void underMaintenanceEvent(BuildContext context) {
  try {
    socket = io("https://car-spa.io", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected For Maintenance Connection💃💃');
      socket.on('maintenance:under', (data) {
        Notifications.createAppIsUnderMaintenanceNotification();
        Navigator.pushNamed(context, MaintenanceScreen.routeName);
      });
    });

    socket.on('error', (data) => print('Error From omar\'s server $data'));
  } catch (e) {
    print(e.toString());
  }
}

//Done maintenance  event ****************************************************************************************
void doneMaintenanceEvent(BuildContext context) {
  try {
    socket = io("https://car-spa.io", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected For Maintenance Connection💃💃');
      socket.on('maintenance:done', (data) {
        Notifications.createAppIsDoneFromMaintenanceNotification();
        //Provider.of<AuthProvider>(context, listen: false).SignOut();
        Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
      });
    });

    socket.on('error', (data) => print('Error From omar\'s server $data'));
  } catch (e) {
    print(e.toString());
  }
}

//Order join event ****************************************************************************************

void orderJoinEvent(int employeeId) {
  print('employee id fromordersConnection  $employeeId');
  try {
    socket = io("https://car-spa.io/orders", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected For Orders Connection💃💃');
    });

    socket.emit('orders:employees:join', {"employeeID": employeeId});

    socket.on('error', (data) => print('error from omar\'s server $data'));
  } catch (e) {
    print('error from the try and catch ${e.toString()}');
  }
}

//Order start event ****************************************************************************************

void orderStartEvent(String orderId) {
  print('order Id from orderStartEvent  $orderId');
  try {
    socket = io("https://car-spa.io/orders", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected For Orders Connection💃💃');
    });

    socket.emit('orders:start', {"orderID": orderId});

    socket.on('error', (data) => print('error from omar\'s server $data'));
  } catch (e) {
    print('error from the try and catch ${e.toString()}');
  }
}
//Order late event ****************************************************************************************

void orderLateEvent(String orderId) {
  print('order Id from orderStartEvent  $orderId');
  try {
    socket = io("https://car-spa.io/orders", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected For Orders Connection💃💃');
    });

    socket.emit('orders:late', {"orderID": orderId});

    socket.on('error', (data) => print('error from omar\'s server $data'));
  } catch (e) {
    print('error from the try and catch ${e.toString()}');
  }
}
//Order finish event event ****************************************************************************************

void orderConfirmEvent(String orderId) {
  print('order Id from orderStartEvent  $orderId');
  try {
    socket = io("https://car-spa.io/orders", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected For Orders Connection💃💃');
    });

    socket.emit('orders:confirm', {"orderID": orderId});

    socket.on('error', (data) => print('error from omar\'s server $data'));
  } catch (e) {
    print('error from the try and catch ${e.toString()}');
  }
}
//Order finish event event ****************************************************************************************

void employeeArrivalEvent(String orderId) {
  print('order Id from orderStartEvent  $orderId');
  try {
    socket = io("https://car-spa.io/orders", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected For Orders Connection💃💃');
    });

    socket.emit('orders:arrival', {"orderID": orderId});

    socket.on('error', (data) => print('error from omar\'s server $data'));
  } catch (e) {
    print('error from the try and catch ${e.toString()}');
  }
}
