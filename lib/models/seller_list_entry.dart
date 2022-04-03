import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/custom/season_appbar.dart';
import 'package:freelance_chef_app/models/seller_item.dart';
import 'package:freelance_chef_app/models/templates_seller_items.dart';
import 'package:provider/src/provider.dart';

import 'interfaces/marketplace_entry.dart';

class SellerListEntry extends MarketplaceEntry {
  SellerItem sellerItem;

  SellerListEntry({Key? key, required this.sellerItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SellerListEntryDetailedView(sellerItem)));
        },
        title: Row(
          children: [
            Column(
              children: [
                Text(sellerItem.title ?? "Null"),
                Text((sellerItem.cost ?? "Null") + " Rub"),
              ],
            ),
            Text("  до  "),
            Text(sellerItem.deadline ?? "Null"),

          ],
        ),
      ),
    );
  }
}

class SellerListEntryDetailedView extends StatelessWidget {
  SellerItem sellerItem;

  SellerListEntryDetailedView(this.sellerItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeasonAppBar(
        titleWidget: Text(sellerItem.title ?? "No name"),
      ).build(context),
      body: ListView(
        children: [
          ListTile(
            title: Row(
              children: [
                Text("Сделать нужно до "),
                Text(sellerItem.deadline ?? "No name"),
              ],
            ),
          ),
          ListTile(
            title: Text("Описание задачи:"),
          ),
          ListTile(
            title: Text(sellerItem.description ?? "No name"),
          ),
          ListTile(
            title: Row(
              children: [
                Text("Стоимость: "),
                Text(sellerItem.cost ?? "No name"),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Text("Заказчик: "),
                Text(sellerItem.customerFullName ?? "No name"),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              if (int.parse(sellerItem.customerId!) != 0) {
                return ListTile(
                  title: RespondButton(sellerItem: sellerItem),
                );
              } else {
                return ListTile(
                  title: ElevatedButton(
                    child: Text("Вы не можете взять свой заказ"),
                    onPressed: null,
                  ),
                );
              }
            },
          ),
          // ListTile(
          //   title: RespondButton(sellerItem: sellerItem),
          // ),
        ],
      ),
    );
  }
}

class RespondButton extends StatefulWidget {

  SellerItem sellerItem;

  RespondButton({Key? key, required this.sellerItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RespondButtonState();
  }

}

class _RespondButtonState extends State<RespondButton> {

  @override
  Widget build(BuildContext context) {
    print(null.runtimeType);
    if (widget.sellerItem.contractorId == null) {
      return ElevatedButton(
        child: Text("Отозваться"),
        onPressed: () {
          if (context
              .read<UserServiceBloc>()
              .getUserInfoOrNull() == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please, login!")));
            return;
          }
          sellerItems.where((element) => element.id! == widget.sellerItem.id!).forEach((element) {
            element.contractorId = "-1";
            element.contractorFullName =
                context.read<UserServiceBloc>().getUserInfo().name ??
                    " " +
                        " " +
                        (context
                            .read<UserServiceBloc>()
                            .getUserInfo()
                            .surname ??
                            " ");
            widget.sellerItem.contractorId = "-1";
            widget.sellerItem.contractorFullName =
                context.read<UserServiceBloc>().getUserInfo().name ??
                    " " +
                        " " +
                        (context
                            .read<UserServiceBloc>()
                            .getUserInfo()
                            .surname ??
                            " ");
          });
          setState(() {});
        },
      );
    } else {
      return ElevatedButton(
        child: Text("Отказаться"),
        onPressed: () {
          sellerItems.where((element) => element.id! == widget.sellerItem.id!).forEach((element) {
            element.contractorId = null;
            element.contractorFullName = null;
            widget.sellerItem.contractorId = null;
            widget.sellerItem.contractorFullName = null;
          });
          setState(() {});
        },
      );
    }

  }

}