import 'package:flutter/services.dart';

class LocalizationRepository {
  LocalizationRepository();

  Future<String> getLocaleJson(String languageCode) async {
    final jsonString = await rootBundle.loadString('assets/i18n/$languageCode.json');
    return jsonString;
  }
}
