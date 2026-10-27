import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ufstech/product_model.dart';

class NetworkServices {
  final url = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> loadService() async {
    final result = await http.get(Uri.parse(url));
    if (result.statusCode == 200 || result.statusCode == 201) {
      final body = jsonDecode(result.body);
      if (body != '') {
        print('body:$body');
        final List<dynamic> data = body;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }
    }
    return [];
  }
}
