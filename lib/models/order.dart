import 'dart:convert';

import 'package:freelance_chef_app/models/interfaces/jsonable.dart';

enum JsonableOrderType {
  Add
}

class Order {
  String? id;
  String? title;
  String? description;
  String? cost;
  String? deadline;
  String? specialId;


  Jsonable getJsonableForm(JsonableOrderType type) {
    switch (type) {
      case JsonableOrderType.Add:
        return OrderAdd(this);
    }
  }

}

class OrderAdd implements Jsonable {

  Order order;

  OrderAdd(this.order);

  @override
  String getJson() {
    return json.encode(<String, dynamic>{
      "title": order.title,
      "description": order.description,
      "cost": int.parse(order.cost!),
      "deadline": order.deadline,
      "specialId": int.parse(order.specialId!)
    });
  }

}