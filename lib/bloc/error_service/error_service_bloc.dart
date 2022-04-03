import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freelance_chef_app/models/interfaces/error_throwable.dart';
import 'package:freelance_chef_app/utils/alert_dialog.dart';
import 'package:meta/meta.dart';

part 'error_service_event.dart';
part 'error_service_state.dart';

class ErrorServiceBloc extends Bloc<ErrorServiceEvent, ErrorServiceState> {

  late BuildContext? _context;

  ErrorServiceBloc(BuildContext? context) : super(ErrorServiceIdle()) {
    _context = context;

    on<ErrorServiceEventThrowError>((event, emit) {
      Future.microtask(
              () => Alert.alertFromBloc(_context!, event.errorMessage.errorMessage!));
      emit(ErrorProduce());
    });

    on<ErrorServiceEventErrorProcessed>((event, emit) {
      emit(ErrorServiceIdle());
    });
  }

  void setContext(BuildContext context) {
    _context = context;
  }
}
