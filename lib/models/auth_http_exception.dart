class HttpExceptionForAuth implements Exception {
  final Map map;

  HttpExceptionForAuth(this.map);

  String toStringMessage() {
    //return super.toString(); instance of HttpException
    return map['message'];
  }

  String toStringField() {
    //return super.toString(); instance of HttpException
    return map['field'];
  }
}
