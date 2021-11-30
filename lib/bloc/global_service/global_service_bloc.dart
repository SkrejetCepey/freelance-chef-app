import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:meta/meta.dart';

part 'global_service_event.dart';

part 'global_service_state.dart';

class GlobalServiceBloc extends Bloc<GlobalServiceEvent, GlobalServiceState>
    implements Networkable {
  BuildContext context;

  GlobalServiceBloc(this.networkBloc, this.context) : super(GlobalServiceInitial()) {

    on<GlobalServiceEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  @override
  NetworkBloc networkBloc;
}
