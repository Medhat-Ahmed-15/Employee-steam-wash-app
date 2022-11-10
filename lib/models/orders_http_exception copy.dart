// ignore_for_file: file_names

class HttpExceptionForOrders implements Exception {
  final String message;

  HttpExceptionForOrders(this.message);

  @override
  String toString() {
    //return super.toString(); instance of HttpException
    return message;
  }
}
