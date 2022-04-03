part of 'error_service_bloc.dart';

@immutable
abstract class ErrorServiceEvent {}

class ErrorServiceEventThrowError extends ErrorServiceEvent {
  late final ErrorMessage errorMessage;

  ErrorServiceEventThrowError(String message) {
    errorMessage = ErrorMessage(message);
  }
}

class ErrorServiceEventErrorProcessed extends ErrorServiceEvent {}
