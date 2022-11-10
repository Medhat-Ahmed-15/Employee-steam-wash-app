// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.white,
      elevation: 1.0,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            Image.asset(
              'assets/images/wait.png',
              width: 120.0,
            ),
            const SizedBox(height: 18.0),
            const Text(
              'Confirming arrival',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10.0,
            ),
            // isLoading == true
            //     ?
            LinearProgressIndicator(
              backgroundColor: Colors.grey[500],
              color: Theme.of(context).primaryColor,
            ),
            // : FlatButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(18.0),
            //         side:
            //             BorderSide(color: Theme.of(context).primaryColor)),
            //     color: colorProviderObj.genralBackgroundColor,
            //     textColor: Theme.of(context).primaryColor,
            //     padding: const EdgeInsets.all(8.0),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     child: Text(
            //       'Ok'.toUpperCase(),
            //       style: const TextStyle(
            //         fontSize: 14.0,
            //       ),
            //     ),
            //   ),
            const SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
