// ignore_for_file: file_names

import 'package:employee_steam_wash_app/Providers/orders_provider.dart';
import 'package:employee_steam_wash_app/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayOrdersTab extends StatefulWidget {
  bool loading;
  DayOrdersTab(this.loading);

  @override
  State<DayOrdersTab> createState() => _DayOrdersTabState();
}

class _DayOrdersTabState extends State<DayOrdersTab> {
  @override
  Widget build(BuildContext context) {
    var ordersList = Provider.of<OrdersProvider>(context).dayOrdersList;

    return widget.loading == true
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return OrderWidget(ordersList[index], 'DayOrders');
            },
            itemCount: ordersList.length,
          );
  }
}
