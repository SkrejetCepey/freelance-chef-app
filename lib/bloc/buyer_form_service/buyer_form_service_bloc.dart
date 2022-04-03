import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/error_throwable.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/interfaces/user_listenable.dart';
import 'package:freelance_chef_app/models/order.dart';
import 'package:freelance_chef_app/network/connection_error.dart';
import 'package:meta/meta.dart';

part 'buyer_form_service_event.dart';

part 'buyer_form_service_state.dart';

BuyerFormServiceState _getSelfStateByUserCurrentState(
    UserServiceState userState) {
  print(userState.runtimeType);
  switch (userState.runtimeType) {
    case UserServiceUserInitialised:
      return BuyerFormServiceAvailable();
    case UserServiceIdle:
      return BuyerFormServiceLock();
    default:
      throw Exception("UnexpectedUserBehavior!");
  }
}

class BuyerFormServiceBloc
    extends Bloc<BuyerFormServiceEvent, BuyerFormServiceState>
    implements Networkable, UserListenable, ErrorThrowable {
  BuyerFormServiceBloc(this.networkBloc, this.userBloc, this.errorServiceBloc)
      : super(_getSelfStateByUserCurrentState(userBloc.state)) {

    // lock for unauthorised accounts
    userBloc.stream.listen((state) {
      emit(_getSelfStateByUserCurrentState(state));
    });

    on<BuyerFormServiceSendData>((event, emit) async {
      emit(BuyerFormServiceWaitData());
      try {
        Order _order = event.order;
        await networkBloc.getConnection().addOrder(_order);
        emit(BuyerFormServiceSuccess("Order created success!"));
      } on ConnectionError catch (e) {
        errorServiceBloc
            .add(ErrorServiceEventThrowError("${e.errorCode}\n${e.errorText}"));
        emit(_getSelfStateByUserCurrentState(userBloc.state));
      }
    });
  }

  @override
  NetworkBloc networkBloc;

  @override
  UserServiceBloc userBloc;

  @override
  ErrorServiceBloc errorServiceBloc;


}
