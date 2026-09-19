import 'package:flutter/material.dart';

import '../data/models/product_model.dart';
import '../data/product_remote_data_source.dart';
import '../data/product_repository_impl.dart';
import '../domain/product_repository.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductRepository productRepository;

  late Future<List<ProductModel>> productsFuture;

  int selectedCategoryIndex = 0;

  final List<String> categories = [
    'All',
    'Jewelry',
    'Bracelets',
    'Pendants',
    'Anklets',
  ];

  @override
  void initState() {
    super.initState();

    final dio = ProductRemoteDataSource.createDio();

    final remoteDataSource = ProductRemoteDataSource(dio);

    productRepository = ProductRepositoryImpl(remoteDataSource);

    productsFuture = productRepository.getProducts();
  }

  Future<void> reloadProducts() async {
    setState(() {
      productsFuture = productRepository.getProducts();
    });

    await productsFuture;
  }

  List<ProductModel> filterProducts(List<ProductModel> products) {
    if (selectedCategoryIndex == 0) {
      return products;
    }

    // ProductModel الحالي لا يحتوي على categories.
    // لذلك نحافظ على نفس شكل الـ categories بدون
    // عمل فلترة وهمية على بيانات غير موجودة في الـ API model.
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.menu_outlined, color: Colors.black87),
          onPressed: () {},
        ),

        title: const Text(
          'YZ ACCESSORIES',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined, color: Colors.black87),
            onPressed: () {},
          ),

          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: FutureBuilder<List<ProductModel>>(
        future: productsFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.grey,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: reloadProducts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final products = snapshot.data!;

          final filteredProducts = filterProducts(products);

          return RefreshIndicator(
            color: Colors.black,

            onRefresh: reloadProducts,

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  buildHeroBanner(),

                  const SizedBox(height: 24),

                  buildSectionTitle('Categories'),

                  const SizedBox(height: 12),

                  buildCategoryList(),

                  const SizedBox(height: 24),

                  buildSectionTitle('Featured Products'),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: GridView.builder(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: filteredProducts.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),

                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return buildProductCard(product);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget buildHeroBanner() {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.all(16),

      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        gradient: const LinearGradient(
          colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'NEW COLLECTION',

            style: TextStyle(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Discover our latest products',

            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,

              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            child: const Text(
              'SHOP NOW',

              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryList() {
    return SizedBox(
      height: 40,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        padding: const EdgeInsets.symmetric(horizontal: 16),

        itemCount: categories.length,

        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),

            child: FilterChip(
              selected: isSelected,

              label: Text(categories[index]),

              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,

                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,

                fontSize: 13,
              ),

              backgroundColor: Colors.white,

              selectedColor: Colors.black87,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),

                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),

              showCheckmark: false,

              onSelected: (selected) {
                setState(() {
                  selectedCategoryIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: Colors.grey.shade200),
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,

                  color: const Color(0xFFF5F5F5),

                  child: Image.network(
                    product.coverPictureUrl,

                    width: double.infinity,
                    height: double.infinity,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),

                if (product.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    left: 8,

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black87,

                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Text(
                        '${product.discountPercentage}% OFF',

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                if (product.rating > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        product.rating.toStringAsFixed(1),

                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 4),

                Text(
                  product.name,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      '${product.price.toStringAsFixed(2)} EGP',

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    InkWell(
                      onTap: () {},

                      borderRadius: BorderRadius.circular(20),

                      child: Container(
                        padding: const EdgeInsets.all(6),

                        decoration: BoxDecoration(
                          color: Colors.black87,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.add_shopping_cart,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
