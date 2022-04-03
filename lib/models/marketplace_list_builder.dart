import 'package:flutter/material.dart';
import 'package:freelance_chef_app/models/seller_list_entry.dart';

class MarketplaceListBuilder extends StatelessWidget {
  final Future<List<SellerListEntry>> marketplaceEntry;

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
          FutureBuilder<List<SellerListEntry>>(
            future: marketplaceEntry,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List my = [];
                List other = [];
                snapshot.data!.forEach((element) {
                  print(element.sellerItem.contractorId);
                  print(null);
                  if (element.sellerItem.contractorId != null) {
                    my.add(element);
                  } else {
                    other.add(element);
                  }
                });
                print(my.length.toString() + " " + other.length.toString());
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Builder(
                      builder: (context) {
                        if (my.isEmpty) {
                          return Container();
                        } else {
                          return ListTile(
                            title: Text("My work:"),
                          );
                        }
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: my.length,
                      itemBuilder: (context, index) {
                        return my[index];
                      },
                    ),
                    ListTile(
                      title: Text("Open orders:"),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: other.length,
                      itemBuilder: (context, index) {
                        return other[index];
                      },
                    ),
                  ],
                );
                // return ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: snapshot.data!.length,
                //   itemBuilder: (context, index) {
                //     return snapshot.data![index];
                //   },
                // );
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
