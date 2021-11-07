import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _urlBase =
      'flutter-products-app-63d37-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  Product? selectedProduct;

  bool isLoading = true;
  bool isSaving = true;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_urlBase, 'products.json');
    final response = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(response.body);

    // Iterate through json and add to list
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // POST
    } else {
      // PUT
      putProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> putProduct(Product product) async {
    final url = Uri.https(_urlBase, 'products/${product.id}.json');
    final response = await http.put(url, body: product.toJson());

    print(response.body);
    // TODO: Update products list
    return '';
  }

  //TODO: Fetch products
}
