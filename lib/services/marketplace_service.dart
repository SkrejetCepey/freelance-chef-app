import 'dart:convert';

import 'package:freelance_chef_app/models/buyer_list_entry.dart';
import 'package:freelance_chef_app/models/interfaces/marketplace_entry.dart';
import 'package:freelance_chef_app/models/seller_item.dart';
import 'package:freelance_chef_app/models/seller_list_entry.dart';
import 'package:freelance_chef_app/models/templates_seller_items.dart';
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

  Future<List<SellerListEntry>> getMarketplaceEntryByCurrentType() async {
    if (_typeMarketPlace == TypeMarketPlace.buyer) {
      return List.generate(sellerItems.length, (i) => SellerListEntry(sellerItem: sellerItems[i]));
    } else if (_typeMarketPlace == TypeMarketPlace.seller) {

      String str = await _connection.getAllOrders();
      // print(str);
      // print(jsonDecode(str));

      // var reqjson = json.decode(string);
      // print(reqjson[0]);
      // print("zalupa");
      // print(SellerItem.fromJson(decodedObjects[0] as Map<String, dynamic>));

      return List.generate(sellerItems.length, (i) => SellerListEntry(sellerItem: sellerItems[i]));
    } else {
      throw Exception("Can't respond current MarketplaceEntry type");
    }
  }
}

enum TypeMarketPlace { buyer, seller }
