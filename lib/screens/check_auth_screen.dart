import 'package:flutter/material.dart';
import 'package:flutter_products_app/screens/screens.dart';
import 'package:flutter_products_app/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: authService.checkToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if theres no token and redirect to login screen
          else if (snapshot.data == '') {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionDuration: const Duration(seconds: 0),
                ),
              );
            });
          }

          // Redirect to home screen since it found a token
          else {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreen(),
                  transitionDuration: const Duration(seconds: 0),
                ),
              );
            });
          }
          return Container();
        },
      )),
    );
  }
}
