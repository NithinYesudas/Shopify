import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/models/httpException.dart';
import 'package:shopify/packages/auth_package.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff4158D0),
                  Color(0xffC850C0),
                  Color(0xffFFCC70)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, .5, 1.5],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: deviceSize.width * .15),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green[700],
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'dmsansbold',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  var errorText;

  void errorDialog(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<AuthPackage>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<AuthPackage>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorText = 'Email not found';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorText = 'Sorry, You have entered a wrong password';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        errorText = 'Email already exists';
      }
      errorDialog(errorText);
    } catch (error) {
      errorText = 'An error Occured';
      errorDialog(errorText);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  late AnimationController _controller;
  late Animation<double> opacityAnimation;
  late Animation<Size> animation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween(
        begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    opacityAnimation = Tween<double>(
        begin: 0, end: 1)
        .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    slideAnimation =
        Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (ctx, child) {
          return Container(
              height: animation.value.height,
              constraints: BoxConstraints(minHeight: animation.value.height),
              width: deviceSize.width * 0.75,
              padding: EdgeInsets.all(16.0),
              child: child);
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),

                AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                  child: FadeTransition(

                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position:slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.Signup,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Signup
                            ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                        }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                    Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Colors.orange[700],
                    textColor: Colors.white,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login
                          ? 'SIGNUP'
                          : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.orange[700],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
