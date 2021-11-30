import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/network/connection.dart';
import 'package:meta/meta.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {

  Connection _connection = Connection(null);

  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  Connection getConnection() => _connection;

  bool isConnectionSupportJwt() => _connection.isConnectionSupportJwt();

}
