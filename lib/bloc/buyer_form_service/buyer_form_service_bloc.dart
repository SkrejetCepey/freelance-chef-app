import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/interfaces/user_listenable.dart';
import 'package:freelance_chef_app/models/mixins/error_throwable.dart';
import 'package:freelance_chef_app/models/order.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'buyer_form_service_event.dart';

part 'buyer_form_service_state.dart';

class BuyerFormServiceBloc
    extends Bloc<BuyerFormServiceEvent, BuyerFormServiceState>
    implements Networkable, UserListenable {
  BuyerFormServiceBloc(this.networkBloc, this.userBloc) : super(BuyerFormServiceInitial()) {

    emit(getSelfStateByUserCurrentState(userBloc.state));
    // lock for unauthorised accounts
    userBloc.stream.listen((state) {
      emit(getSelfStateByUserCurrentState(state));
    });

    on<BuyerFormServiceSendData>((event, emit) async {
      emit(BuyerFormServiceWaitData());
      try {
        Order _order = event.order;
        await networkBloc.getConnection().addOrder(_order);
        emit(BuyerFormServiceSuccess("Order created success!"));
      } on DioError catch (e) {
        emit(getSelfStateByUserCurrentState(userBloc.state)..setErrorMessage("${e.response!.statusCode}\n${e.response!.data}"));
      }
    });
  }

  @override
  NetworkBloc networkBloc;

  @override
  UserServiceBloc userBloc;

  BuyerFormServiceState getSelfStateByUserCurrentState(UserServiceState userState) {
    switch (userState.runtimeType) {
      case UserServiceUserInitialised:
        return BuyerFormServiceAvailable();
      case UserServiceIdle:
        return BuyerFormServiceLock();
      default:
        throw Exception("UnexpectedUserBehavior!");
    }
  }
}
