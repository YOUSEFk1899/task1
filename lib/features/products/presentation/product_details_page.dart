import 'package:flutter/material.dart';

import '../data/models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isDarkMode = false;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final backgroundColor = isDarkMode
        ? const Color(0xFF101010)
        : const Color(0xFFFAFAFA);

    final surfaceColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;

    final textColor = isDarkMode ? Colors.white : Colors.black87;

    final secondaryTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Theme(
      data: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: surfaceColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          ),
          title: Text(
            'Product Details',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
              icon: Icon(
                isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: textColor,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 380,
                    color: isDarkMode
                        ? const Color(0xFF242424)
                        : const Color(0xFFF5F5F5),
                    child: Image.network(
                      product.coverPictureUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_outlined,
                          size: 60,
                          color: secondaryTextColor,
                        );
                      },
                    ),
                  ),

                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${product.discountPercentage}% OFF',
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (product.rating > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      product.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Product Code: ${product.productCode}',
                      style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      '${product.price.toStringAsFixed(2)} EGP',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Divider(
                      color: isDarkMode ? Colors.white12 : Colors.black12,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Description',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      product.description.isEmpty
                          ? 'No description available.'
                          : product.description,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Text(
                          'Stock:',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${product.stock}',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Container(
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.white12
                                  : Colors.black12,
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: quantity > 1
                                    ? () {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    : null,
                                icon: Icon(Icons.remove, color: textColor),
                              ),

                              Text(
                                '$quantity',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              IconButton(
                                onPressed: quantity < product.stock
                                    ? () {
                                        setState(() {
                                          quantity++;
                                        });
                                      }
                                    : null,
                                icon: Icon(Icons.add, color: textColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: product.stock > 0
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Product added to cart'),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: Text(
                          product.stock > 0 ? 'Add to Cart' : 'Out of Stock',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? Colors.white
                              : Colors.black87,
                          foregroundColor: isDarkMode
                              ? Colors.black
                              : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
