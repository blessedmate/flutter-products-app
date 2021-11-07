import 'package:flutter/material.dart';
import 'package:flutter_products_app/providers/login_form_provider.dart';
import 'package:flutter_products_app/ui/custom_input_decorations.dart';
import 'package:flutter_products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

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
          LoginCardContainer(
            cardContent: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 30),

                // Wrap the widget that will be updated in a ChangeNotifierProvider for state management.

                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: const _LoginForm(),
                )
              ],
            ),
          ),
          const SizedBox(height: 50),
          const Text('Create a new account', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Reference to provider
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      // Reference to provider key
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Email Form Field
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: CustomInputDecorations.loginInputDecoration(
              hintText: 'example@mail.com',
              labelText: 'Email',
              prefixIcon: Icons.alternate_email,
            ),
            onChanged: (value) => loginForm.email = value,
            // Email Validator using regular expression
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'Email not valid';
            },
          ),
          const SizedBox(height: 30),

          // Password Form Field
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: CustomInputDecorations.loginInputDecoration(
              hintText: '********',
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              if (value != null && value.length >= 6) {
                return null;
              }
              return 'Must be at least 6 characters long';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? '...' : 'Sign in',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    if (!loginForm.isValidForm()) {
                      return;
                    } else {
                      loginForm.isLoading = true;

                      await Future.delayed(const Duration(seconds: 2));

                      // TODO: Login validation
                      loginForm.isLoading = false;

                      Navigator.pushReplacementNamed(context, 'home');
                    }
                  },
          )
        ],
      ),
    );
  }
}
