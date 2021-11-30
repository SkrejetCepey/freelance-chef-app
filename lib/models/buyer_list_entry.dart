import 'package:flutter/material.dart';

import 'interfaces/marketplace_entry.dart';

class BuyerListEntry extends MarketplaceEntry {
  const BuyerListEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: Text("BuyerCardExample"),
      ),
    );
  }

}