import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:tech_shop/models/http_exception.dart';
import 'package:tech_shop/providers/auth_provider.dart';
import 'package:tech_shop/widgets/login_container.dart';

import '../widgets/lighted_container.dart';

enum AuthPageState {
  login,
  signup,
}

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoginPage = true;
  var _isLoading = false;
  String? email;
  String? password;
  var tempPassword = '';
  var _formKey = GlobalKey<FormState>();

  bool saveAndValidate() {
    if (_formKey.currentState == null) return false;
    if (!_formKey.currentState!.validate()) return false;
    _formKey.currentState!.save();

    return true;
  }

  Future<void> onSubmit(BuildContext context) async {
    if (!saveAndValidate()) return;
    setState(() {
      _isLoading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      isLoginPage
          ? await authProvider.login(email!, password!)
          : await authProvider.signUp(email!, password!);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      switch (error.message) {
        case "EMAIL_EXISTS":
          errorMessage = 'Email already used. Please try to use another one';
          break;
        case "INVALID_EMAIL":
          errorMessage = 'This is not valid email';
          break;
        case "WEAK_PASSWORD":
          errorMessage = "This password is too weak";
          break;
        case "EMAIL_NOT_FOUND":
          errorMessage = "No user with that email";
          break;
        case "INVALID_PASSWORD":
          errorMessage = "Wrong password";
          break;
      }
      _showAlertDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Something went wrong...';
      _showAlertDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showAlertDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: const Text('Error'),
              content: Text(
                errorMessage,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: Alignment.center,
          //height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                LightedContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.05,
                        horizontal: constraints.maxWidth * 0.05),
                    margin: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.05,
                        horizontal: constraints.maxWidth * 0.05),
                    child: Column(
                      children: [
                        Text(
                          'Tech Shop',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontStyle: FontStyle.italic, fontSize: 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Divider(
                            thickness: 3,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          isLoginPage ? 'Login page' : 'Sign up page',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Lato',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: 'Email'),
                                validator: (email) {
                                  if (email!.isEmpty) {
                                    return 'Email can not be empty';
                                  }
                                  var emailRegex = RegExp(
                                      r"/^[a-zA-Z0-9.! #$%&'*+/=? ^_`{|}~-]+@[a-zA-Z0-9-]+(?:\. [a-zA-Z0-9-]+)*$/");

                                  return null;
                                },
                                onSaved: (email) => this.email = email,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: 'Password'),
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return 'Password can not be empty';
                                  }
                                  if (text.length < 6) {
                                    return 'Password must have 6 or more characters';
                                  }
                                  return null;
                                },
                                onChanged: (newPassword) =>
                                    tempPassword = newPassword,
                                onSaved: (password) => this.password = password,
                              ),
                              if (!isLoginPage)
                                Column(
                                  children: [
                                    SizedBox(
                                        height: constraints.maxHeight * 0.03),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: 'Confirm password'),
                                      validator: (text) {
                                        if (tempPassword != text) {
                                          return 'Password does not match';
                                        }
                                        return null;
                                      },
                                      onSaved: (password) =>
                                          this.password = password,
                                    ),
                                  ],
                                ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              SizedBox(
                                width: double.infinity,
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive())
                                    : ElevatedButton(
                                        onPressed: () async {
                                          await onSubmit(context);
                                        },
                                        child: Text(
                                            isLoginPage ? 'Login' : 'Sign up')),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoginPage = !isLoginPage;
                                      _formKey.currentState!.reset();
                                    });
                                  },
                                  child: Text(isLoginPage
                                      ? "Create account"
                                      : 'Back to login'))
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
