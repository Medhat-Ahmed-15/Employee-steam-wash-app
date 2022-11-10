import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child:
              CircularProgressIndicator(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
