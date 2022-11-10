import 'dart:ui';

import 'package:employee_steam_wash_app/Assistants/general_methods.dart';
import 'package:employee_steam_wash_app/models/orderInfo.dart';
import 'package:employee_steam_wash_app/screens/day_order_details_screen.dart';
import 'package:employee_steam_wash_app/screens/upComing_order_details_screen.dart';
import 'package:flutter/material.dart';

class OrderWidget extends StatefulWidget {
  OrderInfo orderInfo;
  String flag;
  OrderWidget(this.orderInfo, this.flag);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  String orderDate;
  String orderTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    orderDate =
        GeneralMethods.convertDateToDayInNumberMonthInText(widget.orderInfo);
    orderTime = GeneralMethods.convertTimeTo12HFormat(widget.orderInfo);
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
                    'Service Type:   ${widget.orderInfo.servicename}',
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
                  if (widget.flag == 'DayOrders') {
                    print('DayOrders');
                    Navigator.pushNamed(
                        context, DayOrderDetailsScreen.routeName,
                        arguments: widget.orderInfo);
                  }
                  if (widget.flag == 'UpComingOrders') {
                    print('UpComingOrders');
                    Navigator.pushNamed(context, UpComingOrdersScreen.routeName,
                        arguments: widget.orderInfo);
                  }
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
