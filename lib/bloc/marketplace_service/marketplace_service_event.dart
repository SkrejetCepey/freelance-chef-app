part of 'marketplace_service_bloc.dart';

@immutable
abstract class MarketplaceServiceEvent {}

class MarketplaceServiceEventSelectType extends MarketplaceServiceEvent {
  final TypeMarketPlace typeMarketPlace;
  MarketplaceServiceEventSelectType(this.typeMarketPlace);
}
