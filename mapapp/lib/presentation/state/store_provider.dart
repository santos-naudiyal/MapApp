import 'package:flutter/material.dart';
import 'package:mapapp/data/models/store_model.dart';

class StoreProvider with ChangeNotifier {
  List<StoreModel> _stores = [];
  StoreModel? _selectedStore;

  List<StoreModel> get stores => _stores;
  StoreModel? get selectedStore => _selectedStore;

  void setStores(List<StoreModel> stores) {
    _stores = stores;
    notifyListeners();
  }

  void selectStore(StoreModel store) {
    _selectedStore = store;
    notifyListeners();
  }
}
