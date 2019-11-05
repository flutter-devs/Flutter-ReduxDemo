import 'package:flutter/material.dart';
import 'package:flutter_redux_example/model/cart_item.dart';
import 'package:flutter_redux_example/my_app.dart';
import 'package:flutter_redux_example/redux/reducers.dart';
import 'package:redux/redux.dart';

import 'model/app_state.dart';

const uploadImage = r"""
mutation($file: Upload!) {
  upload(file: $file)
}
""";

void main() {
  List<CartItem> mainItemList = [
    CartItem("IPhone X"),
    CartItem("Samsung Note 5"),
    CartItem("One Plus 7T"),
    CartItem("Redmi Kpro"),
    CartItem("Nokia 7.2"),
  ];
  final _initialState =
      AppState(cartItemList: List(), mainItemList: mainItemList);
  final Store<AppState> _store =
      Store<AppState>(appStateReducers, initialState: _initialState);
  runApp(MyApp(store: _store));
}
