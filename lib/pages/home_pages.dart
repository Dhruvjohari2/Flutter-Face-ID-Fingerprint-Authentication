import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
          debugPrint('$canAuthenticateWithBiometrics');
          if (canAuthenticateWithBiometrics) {
            try {
              final bool didAuthenticate = await _auth.authenticate(
                  localizedReason: "Please Authenticate So that we can show Your Account Balance",
                  options: const AuthenticationOptions(
                    biometricOnly: false,
                  ));
              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            } catch (e) {
              print(e);
            }
          }
        } else {
          setState(() {
            _isAuthenticated = false;
          });
        }
      },
      child: Icon(!_isAuthenticated ? Icons.lock : Icons.lock_open),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Account Balance'),
          if (_isAuthenticated) Text(' ₹ 27390'),
          if (!_isAuthenticated) Text('*******'),
        ],
      ),
    );
  }
}
