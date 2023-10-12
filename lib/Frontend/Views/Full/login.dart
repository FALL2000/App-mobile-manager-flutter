

// ignore_for_file: no_leading_underscores_for_local_identifiers, camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_money_manager/Utilities/widgets/inputs.dart';
import 'package:x_money_manager/model/MA_Response.dart';
import 'package:x_money_manager/Utilities/widgets/MA_ExitablePage.dart';
import 'package:x_money_manager/utilities/utils.dart';
import 'package:x_money_manager/Frontend/Views/Partials/MA_Spinner.dart';
import 'package:x_money_manager/Backend/MA_loginController.dart';

class MALoginPage extends StatefulWidget {
  const MALoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MALoginPage> {
  // final _usernameController = TextEditingController();
  // final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    // _usernameController.text='mistrel.client@test.net';
    // _passwordController.text='Mistrand';
    // final appState = context.watch<ApplicationState>();
    return Scaffold(
      body:MAExitablePage(child: _loginPage(/*usernameController: _usernameController, passwordController: _passwordController*/),)
       
    );
  }
}


class _loginPage extends StatefulWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
   _loginPage({
    super.key,
    // required TextEditingController usernameController,
    // required TextEditingController passwordController,
  }) /*: _usernameController = usernameController, _passwordController = passwordController*/;

  // final TextEditingController _usernameController;
  // final TextEditingController _passwordController;

  @override
  State<_loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<_loginPage> {
   bool _isloading =false;
   bool _isLoginView =true;

  bool obscureText=true;

   MaResponse? response;
  get obscureLabel=> obscureText ? 'Show Password' : 'Hide Password';
  IconData get obscureIcon=> obscureText ? Icons.visibility : Icons.visibility_off;
  final formKey = GlobalKey<FormState>();


  Future<bool> validate(context) async {
      // await Future.delayed(const Duration(seconds: 1));
      var _valid = formKey.currentState!.validate();
      var message='';
      if (_valid) {
      }
      // _valid ? maShowSnackBar(context, message):''; 
      return _valid;
  }

  @override
  Widget build(BuildContext context) {
    widget._usernameController.text='xunikatrife-8511@yopmail.com';
    widget._passwordController.text='password123';
    ColorScheme colorScheme= Theme.of(context).colorScheme;
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
          print('width >>>> ${constraints.biggest.width} ');
          double spacerBetweenSignIn = constraints.biggest.width/4;
          var _loginFormview = ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              //  SizedBox.fromSize(size: Size(0, 20)),
              const  AspectRatio(aspectRatio: 100 / 35,),
              Column(
                children: <Widget>[
                  Image.asset('assets/logo.png'),
                  const SizedBox(height: 5.0),
                  Text('MONEY APP',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              MAInput(
                prefixIcon: Icon(Icons.mail,color: colorScheme.primary, ),
                controller: widget._usernameController,
                label: 'Email',
              ),
              const SizedBox(height: 20.0),
              MAInput(
                prefixIcon: Icon(Icons.key,color: colorScheme.primary, ),
                controller: widget._passwordController,
                label: 'Password',
                obscureText: obscureText,
                suffixIcon: IconButton(
                        padding: const EdgeInsets.all(0.2),
                        icon: Icon(obscureIcon, color: colorScheme.primary,), //label: Text(''),
                        onPressed: (){
                            setState(() {
                              obscureText = !obscureText;
                            });
                        }, 
                    ),
              ),
              const SizedBox(height: 12.0),
              Row(
                // alignment: MainAxisAlignment.center,
                 mainAxisAlignment : MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      // padding: EdgeInsets.only(right: spacerBetweenSignIn)
                      // primary: Colors.blue,
                      // onSurface: Colors.red,
                    ),
                    child: const Text('Password Forgotten?'),
                    onPressed: () { 
                      toggleView();
                    },
                    
                  ),
                  // SizedBox(width: spacerBetweenSignIn,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom( backgroundColor: colorScheme.primary,foregroundColor: colorScheme.background,minimumSize: const Size(80, 36),),  
                    child: const Text('Log In'),
                    onPressed: () async {
                      await  _handleSignIn(context);
                    },
                  ),
                ],
              ),
              
              // ElevatedButton(onPressed: onPressed, child: child)
              ],
          );

          var _ForgotFormview = ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  const  AspectRatio(aspectRatio: 100 / 30,),
                  Column(
                    children: <Widget>[
                      Image.asset('assets/logo.png'),
                      const SizedBox(height: 5.0),
                      Text('MONEY APP',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  const Text.rich(TextSpan(text: 'In order to recover your password, please enter the email address linked to you account.'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15.0),
                  MAInput(
                    prefixIcon: Icon(Icons.mail,color: colorScheme.primary, ),
                    controller: widget._usernameController,
                    label: 'Email',
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                     mainAxisAlignment : MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        style: TextButton.styleFrom(
                          // padding: EdgeInsets.only(right: spacerBetweenSignIn)
                          // primary: Colors.blue,
                          // onSurface: Colors.red,
                        ),
                        label: const Text('Back'),
                        onPressed: () { 
                          toggleView();
                        },
                        
                      ),
                      // SizedBox(width: spacerBetweenSignIn*1.5,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom( backgroundColor: colorScheme.primary,foregroundColor: colorScheme.background,minimumSize: Size(80, 36),),  
                        child: const Text('Recover'),
                        onPressed: () async {
                            await  _handleRecover(context);
                          },
                      ),
                    ],
                  ),
                  
                  // ElevatedButton(onPressed: onPressed, child: child)
                ],
            );
          return Stack(
            children:[ 
              Form(key: formKey,
                   child: _isLoginView ? _loginFormview : _ForgotFormview
              ),
              Visibility(
                visible: _isloading,
                child: Opacity(
                  opacity: 0.8,
                  child:Container(
                      width: 500,
                      color: Theme.of(context).colorScheme.background,
                      child: MaSpinner(title: 'Wait a moment...',),
                    ),
                  ),
              )         
            ]
                );
          }
         ),
    );


    
  
  }
  void isLoading(bool b){
    setState(() {_isloading=b;});
  }
  void toggleView(){
    setState(() {_isLoginView=!_isLoginView;});
  }
  Future<void> _handleSignIn(BuildContext context) async {
          isLoading(true);
          if(! await validate(context)) return;
          String emailAddress=widget._usernameController.text;
          String password=widget._passwordController.text;
          var _response = await MaLoginController.login(emailAddress, password);
          isLoading(false);
          if (_response.error){
              maShowSnackBar(context: context, message: _response.message, error: true);
          }else{
            Navigator.pop(context);
          } 
  }
  Future<void> _handleRecover(BuildContext context) async {
          isLoading(true);
          if(! await validate(context)) return;
          String emailAddress=widget._usernameController.text;
          // String password=widget._passwordController.text;
          await Future.delayed(Duration(seconds: 5));
          var _response = await MaLoginController.resetPassword(emailAddress);
          isLoading(false);
          if (_response.error){
              maShowSnackBar(context: context, message: _response.message, error: true);
          }else{
              maShowSnackBar(context: context, message: _response.message, success: true);
              toggleView();
          } 
          
  }
}

