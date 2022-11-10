// ignore_for_file: file_names

import 'package:employee_steam_wash_app/Providers/orders_provider.dart';
import 'package:employee_steam_wash_app/widgets/finished_order_widget.dart';
import 'package:employee_steam_wash_app/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinishedOrdersTab extends StatefulWidget {
  @override
  State<FinishedOrdersTab> createState() => _FinishedOrdersTabState();
}

class _FinishedOrdersTabState extends State<FinishedOrdersTab> {
  bool _loadingSpinnerFetchFinishedOrders;
  bool _isInit = true;
  bool emptyFinishedList = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      print('starting finished orders');
      setState(() {
        _loadingSpinnerFetchFinishedOrders = true;
      });
      Provider.of<OrdersProvider>(context, listen: true)
          .fetchFinishedOrders()
          .then((_) {
        setState(() {
          _loadingSpinnerFetchFinishedOrders = false;
        });
      }).catchError((error) {
        setState(() {
          _loadingSpinnerFetchFinishedOrders = false;
          emptyFinishedList = true;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var ordersList = Provider.of<OrdersProvider>(context).finishedOrdersList;
    return _loadingSpinnerFetchFinishedOrders == true
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : emptyFinishedList == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: 300,
                      height: 250,
                      child: Image.asset(
                        'assets/images/zzz.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      child: Text(
                        'You have not finished any orders yet',
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return FinishedOrderWidget(ordersList[index]);
                },
                itemCount: ordersList.length,
              );
  }
}
