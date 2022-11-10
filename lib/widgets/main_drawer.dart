import 'dart:convert';
import 'dart:ui';
import 'package:employee_steam_wash_app/Providers/auth_provider.dart';
import 'package:employee_steam_wash_app/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:employee_steam_wash_app/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Widget buildListTile(IconData iconData, String text, BuildContext context,
      Function onTapFunction) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTapFunction,
          child: ListTile(
            leading: Container(
              width: 35,
              height: 35,
              child: Icon(
                iconData,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              text,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
        Divider(
          height: 30,
          color: Colors.grey[300],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            height: 200,
            alignment: Alignment
                .centerLeft, //THIS CONTROLS HOW THE CHILD OF THE CONTAINER IS ALIGNNED
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 40,
                  child: const CircleAvatar(
                    radius: 37.5,
                    backgroundImage: AssetImage(
                      'assets/images/omar.jpeg',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Provider.of<AuthProvider>(context, listen: false)
                                  .getCurrentUserData ==
                              null
                          ? ''
                          : Provider.of<AuthProvider>(context, listen: false)
                              .getCurrentUserData
                              .username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.grey[300],
                ),
                child: Column(
                  children: [
                    //>>
                    buildListTile(Icons.home, 'Home', context, () {
                      Navigator.of(context)
                          .pushReplacementNamed(MapScreen.routeName);
                    }),

                    //>>
                    buildListTile(Icons.settings, 'Settings', context, () {
                      // Navigator.of(context)
                      //     .pushReplacementNamed(SettingsScreen.routeName);
                    }),

                    //>>
                    buildListTile(Icons.receipt, 'Orders', context, () {
                      Navigator.pushReplacementNamed(
                          context, TabsScreen.routName);
                    }),

                    //>>
                    buildListTile(Icons.exit_to_app, 'Signout', context, () {
                      Navigator.of(context).pop(context);
                      Navigator.of(context).pushReplacementNamed(
                          '/'); //   always go to slash, slash nothing and that is the home route. Since you always go there, you ensure that this logic here in the main.dart file will always run whenever the logout button is pressed and since this always runs and since this home route is always loaded, we will always end up on the AuthScreen when we clear our data in the logout method of the auth provider. So simply add this additional line here and go to your home route to ensure that you never have unexpected behaviors when logging out.
                      Provider.of<AuthProvider>(context, listen: false)
                          .SignOut();
                    }),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
