// ignore_for_file: file_names

class OrderInfo {
  String id;
  String customername;
  String customerphonenumber;
  String orderdate;
  String booktime;
  String servicename;
  double longitude;
  double latitude;
  String locationname;
  String price;

  OrderInfo(
      {this.customername,
      this.id,
      this.booktime,
      this.latitude,
      this.customerphonenumber,
      this.locationname,
      this.longitude,
      this.orderdate,
      this.price,
      this.servicename});

  //another constructor but with different name
  OrderInfo.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    customername = json['customername'];
    customerphonenumber = json['customerphonenumber'];
    orderdate = json['orderdate'];
    booktime = json['booktime'];
    servicename = json['servicename'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    locationname = json['locationname'];
    price = json['price'];
  }
}
