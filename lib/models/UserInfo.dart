// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/foundation.dart';

class UserInfo {
  String id;
  String username;
  String address;
  String nationalid;
  String password;
  bool active;
  bool stillworking;
  String accountcreationdate;
  String phonenumber;

  UserInfo({
    this.id,
    this.username,
    this.address,
    this.nationalid,
    this.password,
    this.active,
    this.stillworking,
    this.accountcreationdate,
    this.phonenumber,
  });
}
