import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_products_app/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _urlBase =
      'flutter-products-app-63d37-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  final storage = FlutterSecureStorage();

  Product? selectedProduct;
  File? newPicture;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_urlBase, 'products.json', {
      'auth': await storage.read(key: 'token'),
    });
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
    final url = Uri.https(_urlBase, 'products/${product.id}.json', {
      'auth': await storage.read(key: 'token'),
    });
    await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    notifyListeners();
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_urlBase, 'products.json', {
      'auth': await storage.read(key: 'token'),
    });
    final response = await http.post(url, body: product.toJson());
    final body = json.decode(response.body);

    product.id = body['name'];

    products.add(product);
    notifyListeners();
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct!.picture = path;
    newPicture = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPicture == null) {
      return null;
    }

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dkwnvvjcs/image/upload?upload_preset=yistplbb');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPicture!.path);
    imageUploadRequest.files.add(file);

    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = json.decode(response.body);

    // Image is uploaded, no need to keep this reference
    newPicture = null;
    // isSaving = false;
    // notifyListeners();

    return body['secure_url'];
  }

  //TODO: Fetch products
}
