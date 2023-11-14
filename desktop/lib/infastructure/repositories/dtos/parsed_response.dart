
const noInternetCode = 404;

class ParsedResponse<R> {
  int statusCode;
  String errorMessages;
  String debugMessages;
  String infoMessages;
  R? payload;

  ParsedResponse({required this.statusCode, required this.errorMessages, required this.debugMessages, required this.infoMessages, required this.payload});

  bool get isOk => statusCode >= 200 && statusCode < 300;
}
