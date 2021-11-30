import 'package:flutter/material.dart';

import 'interfaces/marketplace_entry.dart';

class SellerListEntry extends MarketplaceEntry {
  const SellerListEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text("SellerCardExample"),
      ),
    );
  }

}