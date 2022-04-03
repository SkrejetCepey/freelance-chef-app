import 'dart:convert';

class SellerItem {
  String? id;
  String? title;
  String? description;
  String? contractorId;
  String? contractorFullName;
  String? customerId;
  String? customerFullName;
  List<String?>? info;
  String? cost;
  String? deadline;
  String? specialId;

  SellerItem();

  SellerItem.fromJson(Map<String, dynamic> json) {
    id =  json['id'].toString();
    title = json['title'].toString();
    description = json['description'].toString();
    contractorId = null;
    contractorFullName = null;
    customerId = json['customerId'].toString();
    customerFullName = json['customerFullName'].toString();
    info = [];
    cost = json['cost'].toString();
    deadline = json['deadline'].toString();
    specialId = json['specialId'].toString();
  }
}