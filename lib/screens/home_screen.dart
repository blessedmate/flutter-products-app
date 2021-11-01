import 'package:flutter/material.dart';
import 'package:flutter_products_app/screens/screens.dart';
import 'package:flutter_products_app/services/services.dart';
import 'package:flutter_products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    if (productsService.isLoading) {
      return const LoadingScreen();
    }
    final productsList = productsService.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: productsList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'product'),
          child: ProductCard(product: productsList[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
