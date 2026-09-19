import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';

class ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSource(this.dio);

  static Dio createDio() {
    return Dio();
  }

  Future<Response> getProducts() async {
    return await dio.get(ApiConstants.products);
  }

  Future<Response> getProductById(String id) async {
    return await dio.get('${ApiConstants.products}/$id');
  }
}
