import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_chef_app/bloc/marketplace_service/marketplace_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/models/buyer_form/buyer_form.dart';
import 'package:freelance_chef_app/models/marketplace_list_builder.dart';
import 'package:freelance_chef_app/services/marketplace_service.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MarketplaceServiceBloc>(
      create: (_) => MarketplaceServiceBloc(context.read<NetworkBloc>()),
      child: Builder(
        builder: (context) {
          var marketplaceServiceBloc = context.read<MarketplaceServiceBloc>();
          return DefaultTabController(
            initialIndex:
                marketplaceServiceBloc.getCurrentTypeMarketplaceIndex(),
            length: marketplaceServiceBloc.getTypeMarketplaceSize(),
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.shopping_cart),
                    Text("Marketplace"),
                  ],
                ),
                bottom: TabBar(
                  onTap: (value) => marketplaceServiceBloc.add(
                      MarketplaceServiceEventSelectType(
                          TypeMarketPlace.values[value])),
                  tabs: [
                    Tab(
                      child: Text("Customer"),
                    ),
                    Tab(
                      child: Text("Contractor"),
                    )
                  ],
                ),
              ),
              body: BlocBuilder<MarketplaceServiceBloc, MarketplaceServiceState>(
                builder: (context, state) {
                  if (state is MarketplaceServiceBuyerType) {
                    return BuyerForm();
                  } else if (state is MarketplaceServiceSellerType) {
                    return MarketplaceListBuilder(
                      marketplaceEntry: marketplaceServiceBloc.getMarketplaceEntryListByCurrentType(),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
