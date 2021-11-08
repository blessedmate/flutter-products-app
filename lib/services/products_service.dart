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
      createProduct(product);
    } else {
      // PUT
      updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_urlBase, 'products/${product.id}.json');
    await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    notifyListeners();
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_urlBase, 'products.json');
    final response = await http.post(url, body: product.toJson());
    final body = json.decode(response.body);

    product.id = body['name'];

    products.add(product);
    notifyListeners();
    return product.id!;
  }

  //TODO: Fetch products
}
