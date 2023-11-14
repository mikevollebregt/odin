import 'package:flutter/material.dart';

class VersionNotifier extends ChangeNotifier {
  // TODO: reformat this notifier. I just had one flag, but got feedback to
  // do this in a notifier instead of put this as a global variable in another place.
  static const bool INTERACTION_ALLOWED = true;

  bool isInteractionAllowed() {
    return INTERACTION_ALLOWED;
  }

  // TODO: add logic in future to load versions and other flags per user from backend
}
