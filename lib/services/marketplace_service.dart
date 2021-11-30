import 'package:freelance_chef_app/models/buyer_list_entry.dart';
import 'package:freelance_chef_app/models/interfaces/marketplace_entry.dart';
import 'package:freelance_chef_app/models/seller_list_entry.dart';
import 'package:freelance_chef_app/network/connection.dart';

class MarketplaceService {
  late TypeMarketPlace _typeMarketPlace;
  late Connection _connection;

  MarketplaceService(
      {required TypeMarketPlace typeMarketPlace,
      required Connection connection}) {
    _typeMarketPlace = typeMarketPlace;
    _connection = connection;
  }

  void changeMarketplaceType(TypeMarketPlace typeMarketPlace) {
    _typeMarketPlace = typeMarketPlace;
  }

  TypeMarketPlace getCurrentMarketplaceType() {
    return _typeMarketPlace;
  }

  int getTypeMarketplaceSize() {
    return 2;
  }

  Future<List<MarketplaceEntry>> getMarketplaceEntryByCurrentType() async {
    if (_typeMarketPlace == TypeMarketPlace.buyer) {
      return List.generate(3, (_) => const BuyerListEntry());
    } else if (_typeMarketPlace == TypeMarketPlace.seller) {
      print(await _connection.getAllOrders());
      return List.generate(3, (_) => const SellerListEntry());
    } else {
      throw Exception("Can't respond current MarketplaceEntry type");
    }
  }
}

enum TypeMarketPlace { buyer, seller }
