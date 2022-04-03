import 'dart:math';

import 'package:freelance_chef_app/models/seller_item.dart';
import 'package:freelance_chef_app/models/user.dart';

import 'order.dart';

Map<String, dynamic> sellerItem1 = {
  "id": "13",
  "title": "Hello World",
  "description": "kkk",
  "contractorId": null,
  "contractorFullName": null,
  "customerId": 12,
  "customerFullName": "Борис Коля",
  "info": [],
  "cost": 100,
  "deadline": "2021-10-10T00:00:00",
  "specialId": null
};
Map<String, dynamic> sellerItem2 = {
  "id": "14",
  "title": "Разогреть картошечку",
  "description": "Нужно разогреть картошечку",
  "contractorId": null,
  "contractorFullName": null,
  "customerId": 12,
  "customerFullName": "Борис Коля",
  "info": [],
  "cost": 195,
  "deadline": "2021-12-16T19:45:00",
  "specialId": null
};
Map<String, dynamic> sellerItem3 = {
  "id": "15",
  "title": "Хочу жаренные яйца",
  "description": "Не умею жарить яйца. Серьезно. Можете мне помочь?",
  "contractorId": null,
  "contractorFullName": null,
  "customerId": 15,
  "customerFullName": "Лещенко Алексей",
  "info": [],
  "cost": 500,
  "deadline": "2021-12-17T19:50:00",
  "specialId": null
};
Map<String, dynamic> sellerItem4 = {
  "id": "16",
  "title": "Нужен повар",
  "description": "Требуется повар, я сам из Хабаровска, готовить не умею.",
  "contractorId": null,
  "contractorFullName": null,
  "customerId": 15,
  "customerFullName": "Артем Кулешов",
  "info": [],
  "cost": 1500,
  "deadline": "2021-13-19T20:15:00",
  "specialId": null
};

List<SellerItem> sellerItems = [
  SellerItem.fromJson(sellerItem1),
  SellerItem.fromJson(sellerItem2),
  SellerItem.fromJson(sellerItem3),
  SellerItem.fromJson(sellerItem4),
];

void addSellerItem(Order order, User user) {
  int maxId = -1;
  sellerItems.forEach((element) {
    var n = int.parse(element.id!);
    if (n > maxId) {
      maxId = n;
    }
  });
  if (maxId == -1) {
    throw Exception("maxId == -1");
  }

  Map<String, dynamic> sellerItemTmp = {
    "id": (max<int>(int.parse(order.id ?? "-1"), maxId) + 1).toString(),
    "title": order.title,
    "description": order.description,
    "contractorId": null,
    "contractorFullName": null,
    "customerId": 0,
    "customerFullName": ((user.name ?? " ") + " " + (user.surname ?? " ")),
    "info": [],
    "cost": order.cost,
    "deadline": order.deadline,
    "specialId": null
  };

  sellerItems.add(SellerItem.fromJson(sellerItemTmp));
}