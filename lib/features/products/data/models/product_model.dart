class ProductsResponse {
  final List<ProductModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;

  ProductsResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalCount: json['totalCount'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class ProductModel {
  final String id;
  final String productCode;
  final String name;
  final String description;
  final String coverPictureUrl;
  final double price;
  final int stock;
  final double rating;
  final int discountPercentage;

  ProductModel({
    required this.id,
    required this.productCode,
    required this.name,
    required this.description,
    required this.coverPictureUrl,
    required this.stock,
    required this.rating,
    required this.discountPercentage,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      productCode: json['productCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      coverPictureUrl: json['coverPictureUrl']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toInt() ?? 0,
    );
  }
}
