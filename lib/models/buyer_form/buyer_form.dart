import 'package:flutter/material.dart';
import 'package:freelance_chef_app/bloc/buyer_form_service/buyer_form_service_bloc.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/login_form/login_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../order.dart';
import '../templates_seller_items.dart';
import '../user.dart';
import 'buyer_form_tile.dart';
import 'deadline_list_tile.dart';

class BuyerForm extends StatefulWidget {
  static Order _mapParametersIntoOrder(
      Order order, Map<String, dynamic> parameters) {
    order.title = parameters["title"];
    order.description = parameters["description"];
    order.cost = parameters["cost"];
    order.deadline = parameters["deadline"];
    order.specialId = "0";
    return order;
  }

  // TextEditingController _idController = TextEditingController();

  // TextEditingController _deadlineController = TextEditingController();

  // TextEditingController _specialIdController = TextEditingController();
  // TextEditingController _authorController = TextEditingController();
  Order _order = Order();
  GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _orderParameters = {};

  BuyerForm({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _BuyerFormState();
  }
}

class _BuyerFormState extends State<BuyerForm> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _titleController.addListener(() {
    //   final String text = _titleController.text.toLowerCase();
    //   _titleController.value = _titleController.value.copyWith(
    //     text: text,
    //     selection:
    //     TextSelection(baseOffset: text.length, extentOffset: text.length),
    //     composing: TextRange.empty,
    //   );
    // });
    // _descriptionController.addListener(() {
    //   final String text = _descriptionController.text.toLowerCase();
    //   _descriptionController.value = _descriptionController.value.copyWith(
    //     text: text,
    //     selection:
    //     TextSelection(baseOffset: text.length, extentOffset: text.length),
    //     composing: TextRange.empty,
    //   );
    // });
    // _costController.addListener(() {
    //   final String text = _costController.text.toLowerCase();
    //   _costController.value = _costController.value.copyWith(
    //     text: text,
    //     selection:
    //     TextSelection(baseOffset: text.length, extentOffset: text.length),
    //     composing: TextRange.empty,
    //   );
    // });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<BuyerFormServiceBloc>(
      create: (_) => BuyerFormServiceBloc(context.read<NetworkBloc>(),
          context.read<UserServiceBloc>(), context.read<ErrorServiceBloc>()),
      child: BlocBuilder<BuyerFormServiceBloc, BuyerFormServiceState>(
        builder: (context, state) {
          if (state is BuyerFormServiceSuccess) {
            Future.microtask(() => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.successMessage))));
          }
          if (state is BuyerFormServiceAvailable) {
            if (state is BuyerFormServiceWaitData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Form(
                // autovalidateMode: AutovalidateMode.always,
                key: widget._formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  children: [
                    ListTile(
                      title: Container(
                          alignment: Alignment.center,
                          child: Text("Create new awesome order!")),
                    ),
                    BuyerFormTile(
                      controller: _titleController,
                      valueName: "title",
                      titleValue: "Title",
                      value: widget._orderParameters,
                    ),
                    BuyerFormTile(
                      controller: _descriptionController,
                      valueName: "description",
                      titleValue: "Description",
                      value: widget._orderParameters,
                    ),
                    BuyerFormTile(
                      controller: _costController,
                      valueName: "cost",
                      titleValue: "Cost",
                      value: widget._orderParameters,
                    ),
                    // BuyerFormTile(
                    //   controller: _deadlineController,
                    //   valueName: "deadline",
                    //   titleValue: "Deadline",
                    //   value: _orderParameters,
                    // ),
                    DeadlineListTile(value: widget._orderParameters),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 3),
                      title: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0))),
                        ),
                        onPressed: () {
                          if (widget._formKey.currentState!.validate()) {
                            if (widget._orderParameters["deadline"] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Pick deadline!")));
                              return;
                            }
                            widget._formKey.currentState!.save();
                            context.read<BuyerFormServiceBloc>().add(
                                BuyerFormServiceSendData(
                                    BuyerForm._mapParametersIntoOrder(
                                        widget._order, widget._orderParameters)));

                            // KOSTIL, NE RABOTAET JSON
                            addSellerItem(BuyerForm._mapParametersIntoOrder(
                                widget._order, widget._orderParameters), context.read<UserServiceBloc>().getUserInfo());
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