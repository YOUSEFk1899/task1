import 'package:dio/dio.dart';

import 'products_model.dart';

class ProductService {
  final Dio dio = Dio();

  final String baseUrl = 'https://accessories-eshop.runasp.net/api/products';

  Future<ProductsResponse> fetchProducts() async {
    final response = await dio.get(baseUrl);

    if (response.statusCode == 200) {
      return ProductsResponse.fromJson(response.data);
    }

    throw Exception('Failed to load products');
  }
}
