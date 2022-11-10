// ignore_for_file: file_names

import 'package:employee_steam_wash_app/Assistants/general_methods.dart';
import 'package:employee_steam_wash_app/Socket_IO/stream_socket.dart';
import 'package:employee_steam_wash_app/global_variables.dart';
import 'package:employee_steam_wash_app/models/orderInfo.dart';
import 'package:flutter/material.dart';

class InProgressOrderTab extends StatefulWidget {
  Function emptyInProgresstab;

  InProgressOrderTab(this.emptyInProgresstab);

  @override
  State<InProgressOrderTab> createState() => _InProgressOrderTabState();
}

class _InProgressOrderTabState extends State<InProgressOrderTab> {
  String orderDate;
  String convertedTime;
  OrderInfo inProgressOrderInfoDetails;
  bool loading;
  bool loadingFinishbutton;

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });

    GeneralMethods.getPickedOrder().then((value) {
      inProgressOrderInfoDetails = value;
      orderDate = GeneralMethods.convertDateToDayInNumberMonthInText(
          inProgressOrderInfoDetails);
      convertedTime =
          GeneralMethods.convertTimeTo12HFormat(inProgressOrderInfoDetails);
      setState(() {
        loading = false;
      });
    });
  }

  void finishOrder() async {
    setState(() {
      loadingFinishbutton = true;
    });

    await GeneralMethods.clearStorage();
    orderConfirmEvent(pickedorder.id);
    widget.emptyInProgresstab();

    setState(() {
      loadingFinishbutton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : Column(
            children: [
              //Date text*********************************************************
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: Row(
                  children: const [
                    Icon(Icons.location_on_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Service & Location',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    )
                  ],
                ),
              ),

              const Divider(
                color: Colors.white,
              ),

              //Service and location data*****************************************

              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
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
                              inProgressOrderInfoDetails.servicename,
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
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text(
                      inProgressOrderInfoDetails.locationname,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: Row(
                  children: const [
                    Text(
                      'Cash',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    )
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              //Cash data****************************************
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total cash:',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      '${inProgressOrderInfoDetails.price} LE',
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
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    )
                  ],
                ),
              ),

              const Divider(
                color: Colors.white,
              ),

              //customer data*******************************************************

              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
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
                              inProgressOrderInfoDetails.customername,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              inProgressOrderInfoDetails.customerphonenumber,
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
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 50,
                  width: 400,
                  child: Align(
                    alignment: Alignment.center,
                    child: loadingFinishbutton == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Finish Order',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                onPressed: () {
                  finishOrder();
                },
              ),
            ],
          );
  }
}
