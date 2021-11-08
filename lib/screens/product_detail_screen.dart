import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_products_app/providers/product_form_provider.dart';
import 'package:flutter_products_app/services/services.dart';
import 'package:flutter_products_app/ui/custom_input_decorations.dart';
import 'package:flutter_products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct!),
      child: _ProductDetailBody(productsService: productsService),
    );

    // return _ProductDetailBody(productsService: productsService);
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        // Hide keyboard on scroll
        // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(
                    imageUrl: productsService.selectedProduct!.picture),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 40, color: Colors.white),
                  ),
                ),

                // Camera
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 100,
                      );

                      if (pickedFile == null) {
                        return;
                      }
                      productsService
                          .updateSelectedProductImage(pickedFile.path);
                    },
                    icon: const Icon(Icons.camera_alt_outlined,
                        size: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
            const _ProductForm(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: productsService.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save_outlined),
        onPressed: productsService.isSaving
            ? null
            : () async {
                if (!productFormProvider.isValidForm()) return;

                final String? imageUrl = await productsService.uploadImage();
                if (imageUrl != null) {
                  productFormProvider.product.picture = imageUrl;
                }

                await productsService
                    .saveOrCreateProduct(productFormProvider.product);
              },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildDecoration(),
        child: Form(
          key: productFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                decoration: CustomInputDecorations.loginInputDecoration(
                  hintText: 'Product name',
                  labelText: 'Name:',
                ),
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cant be empty';
                  }
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.price}',
                keyboardType: TextInputType.number,
                decoration: CustomInputDecorations.loginInputDecoration(
                  hintText: '\$150',
                  labelText: 'Price:',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  double.tryParse(value) == null
                      ? product.price == 0
                      : product.price = double.parse(value);
                },
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                title: const Text('Available'),
                activeColor: Colors.orange[800],
                value: product.available,
                // Since onChanged emits a bool and update receives one code can be shortened like this
                onChanged: productFormProvider.updateAvailability,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      );
}
