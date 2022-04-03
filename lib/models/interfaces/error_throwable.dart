import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';

abstract class ErrorThrowable {
  late ErrorServiceBloc errorServiceBloc;
}

class ErrorMessage {
  String? errorMessage;

  ErrorMessage(this.errorMessage);
}