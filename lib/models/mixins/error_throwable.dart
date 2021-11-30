mixin ErrorThrowable on Object {
  ErrorMessage? _errorMessage;

  bool haveUnhandledError() => _errorMessage != null;

  void setErrorMessage(String message) {
    _errorMessage = ErrorMessage(message);
  }

  String getMessageAndHandleError() {
    var message = _errorMessage!.errorMessage!;
    _errorMessage = null;
    return message;
  }
}

class ErrorMessage {
  String? errorMessage;

  ErrorMessage(this.errorMessage);
}