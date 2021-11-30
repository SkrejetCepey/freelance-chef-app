import 'dart:convert';

import 'package:freelance_chef_app/models/interfaces/jsonable.dart';

enum JsonableOrderType {
  Add
}

class Order {
  String? id;
  String? title;
  String? author;


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
    return json.encode(<String, dynamic>{"id": order.id,
      "title": order.title,
      "author": order.author});
  }

}