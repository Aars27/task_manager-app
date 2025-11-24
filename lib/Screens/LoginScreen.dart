import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailC, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passC, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isLogin) {
                  await auth.login(emailC.text, passC.text);
                } else {
                  await auth.signup(emailC.text, passC.text);
                }
              },
              child: Text(isLogin ? "Login" : "Signup"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "Create Account" : "Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}
