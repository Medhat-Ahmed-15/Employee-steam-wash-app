import 'package:employee_steam_wash_app/Providers/orders_provider.dart';
import 'package:employee_steam_wash_app/screens/finished_order_details_screen.dart';
import 'package:employee_steam_wash_app/screens/maintenance_screen.dart';
import 'package:employee_steam_wash_app/screens/map_screen.dart';
import 'package:employee_steam_wash_app/screens/day_order_details_screen.dart';
import 'package:employee_steam_wash_app/screens/signin_screen.dart';
import 'package:employee_steam_wash_app/screens/splash_screen.dart';
import 'package:employee_steam_wash_app/screens/tabs_screen.dart';
import 'package:employee_steam_wash_app/screens/upComing_order_details_screen.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'Providers/address_data_provider.dart';
import 'Providers/auth_provider.dart';

void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/res_notification_app_icon',
    [
      //App is under  Maintenance Notification channel **************************************************************************

      NotificationChannel(
        channelKey:
            'App_Is_Under_Maintenance_Channel', //used to connect our notifications to the specific channels
        channelName:
            'App under Maintenance Notifications', //will be displayed in Android's app’s notification settings.
        defaultColor: const Color.fromRGBO(33, 147, 176, 255).withOpacity(1),
        importance: NotificationImportance
            .High, //to make sure that when our notification is displayed, it peeks out from the top of the screen
        channelShowBadge: true,
        //soundSource: 'resource://raw/res_custom_notification',
      ),

      //App is done from  Maintenance Notification channel **************************************************************************

      NotificationChannel(
        channelKey:
            'App_Is_Done_From_Maintenance_Channel', //used to connect our notifications to the specific channels
        channelName:
            'App Done From Maintenance Notifications', //will be displayed in Android's app’s notification settings.
        defaultColor: const Color.fromRGBO(33, 147, 176, 255).withOpacity(1),
        importance: NotificationImportance
            .High, //to make sure that when our notification is displayed, it peeks out from the top of the screen
        channelShowBadge: true,
        //soundSource: 'resource://raw/res_custom_notification',
      ),

      //Customer cancelled the order Notification channel**************************************************************************

      NotificationChannel(
        channelKey:
            'order_cancelled_Channel', //used to connect our notifications to the specific channels
        channelName:
            'Order cancellation Notifications', //will be displayed in Android's app’s notification settings.
        defaultColor: const Color.fromRGBO(33, 147, 176, 255).withOpacity(1),
        importance: NotificationImportance
            .High, //to make sure that when our notification is displayed, it peeks out from the top of the screen
        channelShowBadge: true,
        soundSource: 'resource://raw/res_custom_notification',
      ),

      //New order Notification channel**************************************************************************

      NotificationChannel(
        channelKey:
            'new_order_Channel', //used to connect our notifications to the specific channels
        channelName:
            'New order Notifications', //will be displayed in Android's app’s notification settings.
        defaultColor: const Color.fromRGBO(33, 147, 176, 255).withOpacity(1),
        importance: NotificationImportance
            .High, //to make sure that when our notification is displayed, it peeks out from the top of the screen
        channelShowBadge: true,
        soundSource: 'resource://raw/res_custom_notification',
      ),
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Providing Auth Data
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),

        //Providing all address Data
        ChangeNotifierProvider(
          create: (context) => AddressDataProvider(),
        ),
        //Providing parking slots  Data
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (ctx) => OrdersProvider(
              token: '',
              dayOrdersList: [],
              upComingOrdersList: [],
              finishedOrdersList: []),
          update: (ctx, authProviderObj, previusOrdersProviderObj) =>
              OrdersProvider(
                  token: authProviderObj.token,
                  dayOrdersList: previusOrdersProviderObj.dayOrdersList,
                  upComingOrdersList:
                      previusOrdersProviderObj.upComingOrdersList,
                  finishedOrdersList:
                      previusOrdersProviderObj.finishedOrdersList),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authProviderObj, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(33, 147, 176, 255).withOpacity(1),
            backgroundColor: Colors.white,
            accentColor: Colors.white,
          ),
          home: authProviderObj.checkauthentication() == true
              ? MapScreen()
              : FutureBuilder(
                  future: authProviderObj.tryAutoSignIn(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : SigninScreen(),
                ),
          routes: {
            MapScreen.routeName: (ctx) => MapScreen(),
            UpComingOrdersScreen.routeName: (ctx) => UpComingOrdersScreen(),
            DayOrderDetailsScreen.routeName: (ctx) => DayOrderDetailsScreen(),
            TabsScreen.routName: (ctx) => TabsScreen(),
            MaintenanceScreen.routeName: (ctx) => MaintenanceScreen(),
            SigninScreen.routName: (ctx) => SigninScreen(),
            FinishedOrdersScreen.routeName: (ctx) => FinishedOrdersScreen(),
          },
        ),
      ),
    );
  }
}
