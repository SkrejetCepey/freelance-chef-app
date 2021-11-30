part of 'buyer_form_service_bloc.dart';

@immutable
abstract class BuyerFormServiceEvent {}

class BuyerFormServiceSendData extends BuyerFormServiceEvent {
  final Order order;

  BuyerFormServiceSendData(this.order);
}