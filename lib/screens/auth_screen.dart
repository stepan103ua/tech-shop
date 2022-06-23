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
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;
  late AnimationController _animationController;
  late double deviceHeight;

  final animationDuration = 300;
  final _animationCurve = Curves.easeIn;
  var isLoginPage = true;
  var _isLoading = false;
  String? email;
  String? password;
  var tempPassword = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: animationDuration));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: _animationCurve));
    super.initState();
  }

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
    deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                LightedContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: deviceHeight * 0.05,
                        horizontal: constraints.maxWidth * 0.05),
                    margin: EdgeInsets.symmetric(
                        vertical: deviceHeight * 0.05,
                        horizontal: constraints.maxWidth * 0.05),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: animationDuration),
                      curve: _animationCurve,
                      height: isLoginPage
                          ? deviceHeight * 0.45
                          : deviceHeight * 0.53,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: deviceHeight * 0.05,
                              child: FittedBox(
                                child: Text(
                                  'Tech Shop',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 40),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: deviceHeight * 0.01),
                              child: const Divider(
                                thickness: 3,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.04,
                              child: FittedBox(
                                child: Text(
                                  isLoginPage ? 'Login page' : 'Sign up page',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Lato',
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.05,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: deviceHeight * 0.05,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: 'Email'),
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
                                  ),
                                  SizedBox(height: deviceHeight * 0.03),
                                  SizedBox(
                                    height: deviceHeight * 0.05,
                                    child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: 'Password'),
                                        validator: (text) {
                                          if (text!.isEmpty) {
                                            print('next');
                                            return 'Password can not be empty';
                                          }
                                          if (text.length < 6) {
                                            return 'Password must have 6 or more characters';
                                          }
                                          return null;
                                        },
                                        onChanged: (newPassword) =>
                                            tempPassword = newPassword,
                                        onSaved: (password) {
                                          this.password = password;
                                          print(this.password);
                                        }),
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: animationDuration),
                                    height:
                                        isLoginPage ? 0 : deviceHeight * 0.08,
                                    child: FadeTransition(
                                      opacity: _opacityAnimation,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: deviceHeight * 0.03,
                                            ),
                                            SizedBox(
                                              height: deviceHeight * 0.05,
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Confirm password'),
                                                validator: (text) {
                                                  if (isLoginPage) {
                                                    return null;
                                                  }
                                                  if (tempPassword != text ||
                                                      text!.isEmpty) {
                                                    return 'Password does not match';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: deviceHeight * 0.03),
                                  SizedBox(
                                    width: constraints.maxWidth,
                                    height: deviceHeight * 0.05,
                                    child: _isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator
                                                .adaptive())
                                        : ElevatedButton(
                                            onPressed: () async {
                                              await onSubmit(context);
                                            },
                                            child: Text(isLoginPage
                                                ? 'Login'
                                                : 'Sign up')),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.06,
                                    child: FittedBox(
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isLoginPage = !isLoginPage;
                                              _formKey.currentState!.reset();
                                              isLoginPage
                                                  ? _animationController
                                                      .reverse()
                                                  : _animationController
                                                      .forward();
                                            });
                                          },
                                          child: Text(isLoginPage
                                              ? "Create account"
                                              : 'Back to login')),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
