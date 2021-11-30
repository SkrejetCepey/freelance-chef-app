import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelance_chef_app/models/interfaces/marketplace_entry.dart';

class MarketplaceListBuilder extends StatelessWidget {
  final Future<List<MarketplaceEntry>> marketplaceEntry;

  const MarketplaceListBuilder({Key? key, required this.marketplaceEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 25.0,
          ),
          FutureBuilder<List<MarketplaceEntry>>(
            future: marketplaceEntry,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return snapshot.data![index];
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
