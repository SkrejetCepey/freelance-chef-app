part of 'marketplace_service_bloc.dart';

@immutable
abstract class MarketplaceServiceState {}

class MarketplaceServiceInitial extends MarketplaceServiceState {}

class MarketplaceServiceBuyerType extends MarketplaceServiceState {}
class MarketplaceServiceSellerType extends MarketplaceServiceState {}

class MarketplaceServiceError extends MarketplaceServiceState {}

