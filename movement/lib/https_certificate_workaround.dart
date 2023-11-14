import 'dart:io';

void enableUnverifiedHttpsCertificate() {
  HttpOverrides.global = DevHttpOverrides();
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        if (host.isNotEmpty && host == '188.166.119.164') {
          return true;
        } else {
          return false;
        }
      };
  }
}
