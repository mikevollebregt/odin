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
}

class Error extends NotifierState {
  final String message;
  const Error(this.message);
}
