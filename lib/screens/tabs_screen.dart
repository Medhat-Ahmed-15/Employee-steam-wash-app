//import 'dart:io';

import 'package:employee_steam_wash_app/Assistants/general_methods.dart';
import 'package:employee_steam_wash_app/Providers/orders_provider.dart';
import 'package:employee_steam_wash_app/Socket_IO/stream_socket.dart';
import 'package:employee_steam_wash_app/global_variables.dart';
import 'package:employee_steam_wash_app/tabs/day_orders_tab.dart';
import 'package:employee_steam_wash_app/tabs/finished_orders_tab.dart';
import 'package:employee_steam_wash_app/tabs/inProgressOrder_tab.dart';
import 'package:employee_steam_wash_app/tabs/upComing_orders_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static final routName = '/tabs_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  bool _isInit = true;
  bool _loadingSpinnerFetchDayOrders = false;
  bool _loadingSpinnerFetchLaterOrders = false;
  bool emptyDayList = false;
  bool emptyLaterList = false;
  bool enableInProgressTab = false;

  @override
  void didChangeDependencies() {
    //  and now here we shouldn't use async await here for didChangeDependencies or for initState because these are not methods which return futures  normally and since you override the built-in methods, you shouldn't change what they return. So using async here would change what they return because an async method always returns a future and  therefore, don't use async await here but here, I will use the old approach with then
    if (_isInit) {
      orderJoinEvent(int.parse(currentEmployeeId));
      setState(() {
        _loadingSpinnerFetchDayOrders = true;
        _loadingSpinnerFetchLaterOrders = true;
      });

      //Fetching Today Orders***************************************************
      Provider.of<OrdersProvider>(context).fetchDayOrders().then((_) {
        setState(() {
          _loadingSpinnerFetchDayOrders = false;
        });
      }).catchError((error) {
        setState(() {
          emptyDayList = true;
        });
      });

      //Fetching Upcoming Orders***************************************************

      Provider.of<OrdersProvider>(context).fetchLaterOrders().then((_) {
        setState(() {
          _loadingSpinnerFetchLaterOrders = false;
        });
      }).catchError((error) {
        setState(() {
          emptyLaterList = true;
        });
      });

      //Fetching Finished Orders***************************************************

      //Fetching Employee Status***************************************************

      GeneralMethods.getEmployeeStatus().then((value) {
        print('value $value');
        if (value == 'arrived') {
          setState(() {
            enableInProgressTab = true;
          });
        } else {}
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void emptyInProgresstab() {
    setState(() {
      enableInProgressTab = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: enableInProgressTab == true ? 4 : 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Orders',
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              if (enableInProgressTab == true)
                const Tab(
                  icon: Icon(Icons.move_to_inbox),
                  text: 'In progress order',
                ),
              const Tab(
                icon: Icon(Icons.today),
                text: 'Today orders',
              ),
              const Tab(
                icon: Icon(Icons.upcoming),
                text: 'Upcoming Orders',
              ),
              const Tab(
                icon: Icon(Icons.done),
                text: 'Finished Orders',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            if (enableInProgressTab == true)
              InProgressOrderTab(emptyInProgresstab),
////////////////////////////////////////////////////////////////////////////////
            emptyDayList == true
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
                            'You have got no orders today',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    ),
                  )
                : DayOrdersTab(_loadingSpinnerFetchDayOrders),

////////////////////////////////////////////////////////////////////////////////
            emptyLaterList == true
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
                            'You have got no upcoming orders',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[500]),
                          ),
                        ),
                      ],
                    ),
                  )
                : UpComingOrdersTab(_loadingSpinnerFetchLaterOrders),

////////////////////////////////////////////////////////////////////////////////
            FinishedOrdersTab(),
          ],
        ),
      ),
    );
  }
}
