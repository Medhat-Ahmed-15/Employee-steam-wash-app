// ignore_for_file: file_names

import 'package:employee_steam_wash_app/Assistants/general_methods.dart';
import 'package:employee_steam_wash_app/Providers/orders_provider.dart';
import 'package:employee_steam_wash_app/models/finishedOrderInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinishedOrdersScreen extends StatefulWidget {
  static const routeName = '/FinishedOrdersScreen';

  @override
  State<FinishedOrdersScreen> createState() => _FinishedOrdersScreen();
}

class _FinishedOrdersScreen extends State<FinishedOrdersScreen> {
  FinishedOrderInfo orderInfoDetails;
  String orderDate;
  String convertedTime;

  @override
  Widget build(BuildContext context) {
    orderInfoDetails =
        ModalRoute.of(context).settings.arguments as FinishedOrderInfo;

    orderDate =
        GeneralMethods.convertDateToDayInNumberMonthInTextForFinishedOrders(
            orderInfoDetails);
    convertedTime = GeneralMethods.convertTimeTo12HFormatForFinishedOrders(
        orderInfoDetails);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Order details',
          ),
        ),
        body: Column(
          children: [
            //Date text*********************************************************
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Row(
                children: [
                  const Icon(Icons.date_range_rounded),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    orderDate + ',' + convertedTime,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 15),
                  )
                ],
              ),
            ),
            Expanded(child: Container()),

            //Service and location title****************************************
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Row(
                children: const [
                  Icon(Icons.location_on_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Service & Location',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            //Service and location data*****************************************

            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/images/service.png'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderInfoDetails.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Text(
                            'One service includes many',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey[500]),
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    orderInfoDetails.locationname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            Expanded(child: Container()),

            //Cash title****************************************
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Row(
                children: const [
                  Text(
                    'Cash',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            //Cash data****************************************
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total cash:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  Text(
                    '${orderInfoDetails.price} LE',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),

            Expanded(child: Container()),

            //Customer data title****************************************
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Row(
                children: const [
                  Icon(Icons.person),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Customer Data',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                  )
                ],
              ),
            ),

            //customer data*******************************************************
            const Divider(
              color: Colors.white,
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 40,
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 37.5,
                            backgroundImage: AssetImage(
                              'assets/images/me.jpeg',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderInfoDetails.customerusername,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'His Rating: ${countStars(orderInfoDetails.rating)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.grey[500]),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            Expanded(child: Container()),
            FlatButton(
              child: Container(
                margin: EdgeInsets.only(bottom: 60, left: 50, right: 50),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 50,
                width: 400,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Clear Order',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onPressed: () {
                // Provider.of<OrdersProvider>(context, listen: false)
                //     .clearFinishedOrder(orderInfoDetails.id);
                null;
              },
            ),
          ],
        ));
  }

  String countStars(int rating) {
    String stars = "";
    for (int i = 0; i < rating; i++) {
      stars = stars + '⭐';
    }
    return stars;
  }
}
