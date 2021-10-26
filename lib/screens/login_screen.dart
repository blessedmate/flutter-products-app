import 'package:flutter/material.dart';
import 'package:flutter_products_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: LoginBackground(
        loginBox: _LogInBox(size: size),
      ),
    );
  }
}

class _LogInBox extends StatelessWidget {
  const _LogInBox({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.3),
          CardContainer(
            cardContent: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 30),
                const Text('Form')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
