import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:tech_shop/widgets/lighted_container.dart';

class LoginContainer extends StatefulWidget {
  const LoginContainer({Key? key}) : super(key: key);

  @override
  State<LoginContainer> createState() => _LoginContainerState();
}

class _LoginContainerState extends State<LoginContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: SizedBox(
          height: constraints.maxHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontStyle: FontStyle.italic, fontSize: 40),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Divider(
                          thickness: 3,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Login page',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Lato',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.05,
                      ),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: 'Email'),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.03),
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: 'Password'),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.03),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Log in')),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: const Text("Create account"))
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
