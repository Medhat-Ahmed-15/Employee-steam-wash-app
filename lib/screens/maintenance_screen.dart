// ignore_for_file: missing_return

import 'package:employee_steam_wash_app/Socket_IO/stream_socket.dart';
import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  static const routeName = '/MaintenanceScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: EdgeInsetsDirectional.all(15),
            child: Image.asset('assets/images/maintenance.png'),
          ),
          Text(
            'SteamWash is currently down for maintenance.\nWe expect to be back in a couple hours. chill out 😴',
            style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          LinearProgressIndicator(),
        ]),
      ),
    );
  }
}
