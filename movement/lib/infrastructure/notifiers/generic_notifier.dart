import 'package:flutter/material.dart';

abstract class NotifierState {
  const NotifierState();
}

class Initial extends NotifierState {
  const Initial();
}

class Loading extends NotifierState {
  const Loading();
}

class Loaded<T> extends NotifierState {
  final T loadedObject;
  const Loaded(this.loadedObject);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Loaded;
  }
}

@immutable
class Error extends NotifierState {
  final String message;
  const Error(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Error && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
