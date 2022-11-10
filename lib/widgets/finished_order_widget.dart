import 'dart:ui';

import 'package:employee_steam_wash_app/Assistants/general_methods.dart';
import 'package:employee_steam_wash_app/models/finishedOrderInfo.dart';
import 'package:employee_steam_wash_app/models/orderInfo.dart';
import 'package:employee_steam_wash_app/screens/day_order_details_screen.dart';
import 'package:employee_steam_wash_app/screens/finished_order_details_screen.dart';
import 'package:employee_steam_wash_app/screens/upComing_order_details_screen.dart';
import 'package:flutter/material.dart';

class FinishedOrderWidget extends StatefulWidget {
  FinishedOrderInfo orderInfo;
  FinishedOrderWidget(this.orderInfo);

  @override
  State<FinishedOrderWidget> createState() => _FinishedOrderWidget();
}

class _FinishedOrderWidget extends State<FinishedOrderWidget> {
  String orderDate;
  String orderTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderDate =
        GeneralMethods.convertDateToDayInNumberMonthInTextForFinishedOrders(
            widget.orderInfo);
    orderTime = GeneralMethods.convertTimeTo12HFormatForFinishedOrders(
        widget.orderInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 2.0,
              spreadRadius: 1,
              offset: const Offset(0.2, 0.2),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: FittedBox(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Service Type:   ${widget.orderInfo.name}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      const Text('Date: '),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        orderDate,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Time: '),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        orderTime,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Price:'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('${widget.orderInfo.price} LE'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FlatButton(
                onPressed: () {
                  print('Finished orders');
                  Navigator.pushNamed(context, FinishedOrdersScreen.routeName,
                      arguments: widget.orderInfo);
                },
                child: Text(
                  'Show more details>',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                      decoration: TextDecoration.underline),
                ))
          ],
        ),
      ),
    );
  }
}
