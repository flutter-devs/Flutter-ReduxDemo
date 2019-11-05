import 'package:flutter_redux_example/model/cart_item.dart';

class AppState {
  List<CartItem> cartItemList = List<CartItem>();
  List<CartItem> mainItemList = List<CartItem>();

  AppState({this.cartItemList, this.mainItemList});

  AppState.fromAppState(AppState another) {
    cartItemList = another.cartItemList;
    mainItemList = another.mainItemList;
  }
}
