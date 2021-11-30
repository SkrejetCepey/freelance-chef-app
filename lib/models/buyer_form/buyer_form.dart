import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/buyer_form_service/buyer_form_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/login_form/login_form.dart';
import 'package:freelance_chef_app/utils/alert_dialog.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../order.dart';
import 'buyer_form_tile.dart';

class BuyerForm extends StatelessWidget {
  static Order _mapParametersIntoOrder(
      Order order, Map<String, dynamic> parameters) {
    order.id = parameters["id"];
    order.title = parameters["title"];
    order.author = parameters["author"];
    return order;
  }

  TextEditingController _idController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey();
  Order _order = Order();
  Map<String, dynamic> _orderParameters = {};

  BuyerForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BuyerFormServiceBloc>(
      create: (_) => BuyerFormServiceBloc(
          context.read<NetworkBloc>(), context.read<UserServiceBloc>()),
      child: BlocBuilder<BuyerFormServiceBloc, BuyerFormServiceState>(
        builder: (context, state) {
          if (state.haveUnhandledError()) {
            Future.microtask(
                () => Alert.alert(context, state.getMessageAndHandleError()));
          }
          if (state is BuyerFormServiceAvailable) {
            if (state is BuyerFormServiceWaitData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Form(
                // autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  children: [
                    ListTile(
                      title: Container(
                          alignment: Alignment.center,
                          child: Text("Create new awesome order!")),
                    ),
                    BuyerFormTile(
                      controller: _idController,
                      valueName: "id",
                      titleValue: "ID",
                      value: _orderParameters,
                    ),
                    BuyerFormTile(
                      controller: _titleController,
                      valueName: "title",
                      titleValue: "Title",
                      value: _orderParameters,
                    ),
                    BuyerFormTile(
                      controller: _authorController,
                      valueName: "author",
                      titleValue: "Author",
                      value: _orderParameters,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 150.0),
                      title: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.black))),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            context.read<BuyerFormServiceBloc>().add(
                                BuyerFormServiceSendData(
                                    _mapParametersIntoOrder(
                                        _order, _orderParameters)));
                          }
                        },
                        child: Text("Create!"),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else if (state is BuyerFormServiceLock) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text("Login!"),
                  onPressed: () async {
                    LoginForm.showMyDialog(context);
                  },
                ),
                Center(
                  child: Text("Login to create new order!"),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("BuyerFormState machine is broken :C"),
            );
          }
        },
      ),
    );
  }
}
