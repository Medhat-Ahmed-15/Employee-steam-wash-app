// ignore_for_file: file_names

class FinishedOrderInfo {
  String id;
  String customerusername;
  String orderdate;
  String booktime;
  String name;
  int rating;
  double longitude;
  double latitude;
  String locationname;
  String price;

  FinishedOrderInfo(
      {this.customerusername,
      this.id,
      this.rating,
      this.booktime,
      this.latitude,
      this.locationname,
      this.longitude,
      this.orderdate,
      this.price,
      this.name});

  //another constructor but with different name
  FinishedOrderInfo.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    customerusername = json['customerusername'];
    orderdate = json['orderdate'];
    booktime = json['booktime'];
    name = json['name'];
    rating = json['rating'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    locationname = json['locationname'];
    price = json['price'];
  }
}
