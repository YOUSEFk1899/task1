import '../domain/product_repository.dart';
import 'models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await remoteDataSource.getProducts();

    final productsResponse = ProductsResponse.fromJson(response.data);

    return productsResponse.items;
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await remoteDataSource.getProductById(id);

    return ProductModel.fromJson(response.data);
  }
}
