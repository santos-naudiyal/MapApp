import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/store_services.dart';
import 'presentation/screens/store_screen.dart';
import 'presentation/state/store_provider.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
      create: (_) => StoreProvider(),
      child: MyApp(),
    ),
        
      ],
      child: MaterialApp(
        title: 'Store Locator',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: StoreScreen(),
      ),
    );
  }
}
