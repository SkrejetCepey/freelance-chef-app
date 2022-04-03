import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/marketplace_entry.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/seller_list_entry.dart';
import 'package:freelance_chef_app/services/marketplace_service.dart';
import 'package:meta/meta.dart';

part 'marketplace_service_event.dart';

part 'marketplace_service_state.dart';

class MarketplaceServiceBloc
    extends Bloc<MarketplaceServiceEvent, MarketplaceServiceState>
    implements Networkable {
  late final MarketplaceService _marketplaceService = MarketplaceService(
      typeMarketPlace: TypeMarketPlace.buyer, connection: networkBloc.getConnection());

  MarketplaceServiceBloc(this.networkBloc)
      : super(MarketplaceServiceInitial()) {
    emit(_getStateByCurrentServiceType());

    on<MarketplaceServiceEventSelectType>((event, emit) async {
      _marketplaceService.changeMarketplaceType(event.typeMarketPlace);
      emit(_getStateByCurrentServiceType());
    });
  }

  int getTypeMarketplaceSize() {
    return _marketplaceService.getTypeMarketplaceSize();
  }

  int getCurrentTypeMarketplaceIndex() {
    return _marketplaceService.getCurrentMarketplaceType().index;
  }

  Future<List<SellerListEntry>> getMarketplaceEntryListByCurrentType() async {
    return await _marketplaceService.getMarketplaceEntryByCurrentType();
  }

  MarketplaceServiceState _getStateByCurrentServiceType() {
    switch (_marketplaceService.getCurrentMarketplaceType()) {
      case TypeMarketPlace.buyer:
        return MarketplaceServiceBuyerType();
      case TypeMarketPlace.seller:
        return MarketplaceServiceSellerType();
    }
  }

  @override
  NetworkBloc networkBloc;
}
