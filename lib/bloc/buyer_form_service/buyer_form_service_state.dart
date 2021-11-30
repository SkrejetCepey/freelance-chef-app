part of 'buyer_form_service_bloc.dart';

@immutable
abstract class BuyerFormServiceState with ErrorThrowable {}

class BuyerFormServiceInitial extends BuyerFormServiceState {}
class BuyerFormServiceAvailable extends BuyerFormServiceState {}
class BuyerFormServiceLock extends BuyerFormServiceState {}

class BuyerFormServiceSuccess extends BuyerFormServiceAvailable {
  String successMessage;

  BuyerFormServiceSuccess(this.successMessage);
}

class BuyerFormServiceWaitData extends BuyerFormServiceAvailable {}