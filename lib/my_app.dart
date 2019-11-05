import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_example/cartList.dart';
import 'package:flutter_redux_example/home_page.dart';
import 'package:flutter_redux_example/model/app_state.dart';
import 'package:flutter_redux_example/upload_imageScreen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:redux/redux.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    final httpLink = HttpLink(
      uri: 'http://letsinspire.aeologic.com/admin/graphql',
    );
    var client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink,
      ),
    );
    return StoreProvider<AppState>(
      store: store,
      child: GraphQLProvider(
        client: client,
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
          routes: {
            '/home': (context) => HomePage(),
            '/cart': (context) => CartList(),
            '/upload': (context) => UploadImageScreen(),
          },
        ),
      ),
    );
  }
}
