import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/data/models/store_model.dart';

class StoreService {
  Future<List<StoreModel>> fetchStores() async {
    final response = await http.get(Uri.parse('https://atomicbrain.neosao.online/nearest-store'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      return data.map((store) => StoreModel.fromJson(store)).toList();
    } else {
      throw Exception('Failed to load stores');
    }
  }
}
