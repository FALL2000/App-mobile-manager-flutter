

/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_money_manager/data/localStorage/MA_LocalStore.dart';
import 'package:x_money_manager/data/states/app_state.dart';
import 'package:x_money_manager/model/MA_Response.dart';
import 'package:x_money_manager/model/MA_User.dart';
import 'package:x_money_manager/utilities/inputs.dart';
import 'package:x_money_manager/utilities/utils.dart';
import 'package:x_money_manager/views/partials/MA_Spinner.dart';
import 'package:x_money_manager/views/partials/auth/MA_EmailPasswordAuth.dart';
import 'package:x_money_manager/views/partials/auth/MA_UserCompleteInfo.dart';
import 'package:provider/provider.dart';
import '../../controller/MA_loginController.dart';

import '../../utilities/MA_ExitablePage.dart';
import '../../utilities/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          // if(info.inCountryId == info.outCountryId) {
          //   _valid=false;
          //   message='Depart country must be different from the destination country';
          //   maShowSnackBar(context:context, message:message,error: true);
          // }else{
          //   // if(kDebugMode)
          //     // maShowSnackBar(context:context, message:'Cool!',success: true); // to comment later
          // }
      }
      // _valid ? maShowSnackBar(context, message):''; 
      return _valid;
  }

  @override
  Widget build(BuildContext context) {
     final appProvider = Provider.of<ApplicationState>(context);
    widget._usernameController.text='mistrel.client@test.net';
    widget._passwordController.text='Mistrand';
    ColorScheme colorScheme= Theme.of(context).colorScheme;
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
          print('width >>>> ${constraints.biggest.width} ');
          double spacerBetweenSignIn = constraints.biggest.width/4;
          return Stack(
            children:[ Form(
                  key: formKey,
                  child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          children: <Widget>[
                            const SizedBox(height: 10.0),
                            Column(
                              children: <Widget>[
                                Image.asset('assets/logo.png'),
                                const SizedBox(height: 5.0),
                                Text(
                                  'MONEY APP',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40.0),
                            MAInput(
                              controller: widget._usernameController,
                              label: 'Username',
                            ),
                            const SizedBox(height: 12.0),
                            MAInput(
                              controller: widget._passwordController,
                              label: 'Password',
                              obscureText: obscureText,
                              suffix: IconButton(
                                padding: EdgeInsets.all(0.2),
                                icon: Icon(obscureIcon, color: colorScheme.primary,), //label: Text(''),
                                onPressed: (){
                                        // print('value $value');
                                        setState(() {
                                            obscureText = !obscureText;
                                          });
                                  }, ),
                            ),
                            const SizedBox(height: 12.0),
                            OverflowBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.only(right: spacerBetweenSignIn)
                                    // primary: Colors.blue,
                                    // onSurface: Colors.red,
                                  ),
                                  child: Text('Forgot Password ?'),
                                  onPressed: () { },
                                  
                                ),
                                ElevatedButton(style: ElevatedButton.styleFrom( backgroundColor: colorScheme.primary,foregroundColor: colorScheme.background,
                                                    minimumSize: Size(80, 36),),  
                                              child: Text('Sign In'),
                                              onPressed: () async {
                                                  await  _handleSignIn(context);
                                                },
                              ),
                              ],
                            ),
                            Divider(thickness: 2,),
                            ElevatedButton.icon(onPressed: ()async{
                              if(await _handleSignWithgoogle()){
                                appProvider.storedUser= MaUser.fromJson({
                                  'email' : appProvider.authUser?.email,
                                  'lastname' : appProvider.authUser?.displayName,
                                  'phone' : appProvider.authUser?.phoneNumber,
                                });
                                if(!MaLocalStore.checkUserData()){//is new user
                                    while (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => MAExitablePage(child:MaUserCompleteInfo())),
                                    );
                              }else{//old user
                                  while (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                    Navigator.pushReplacementNamed(context, '/');
                              }
                              }
                            },icon: Container(
                                  margin: const EdgeInsets.all(5),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/google.png"),
                                    ),
                                  ),
                                ),
                                label: Text('Sign In with google'),
                              // style: ElevatedButton.styleFrom(backgroundColor: colorScheme.secondary, foregroundColor: colorScheme.background),
                            ),
                            OutlinedButton(onPressed: (){
                              Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => MaEmailPasswordAuth ()),
                                    );
                            }, child: Text('Create an account')),
                            // ElevatedButton(onPressed: onPressed, child: child)
                            ],
                          )
                        ),
               

            Visibility(
                visible: _isloading,
                child: Opacity(
                  opacity: 0.8,
                  child:Container(
                    width: 500,
                    color: Theme.of(context).colorScheme.background,
                    child: MaSpinner()
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
  Future<void> _handleSignIn(BuildContext context) async {
          if(! await validate(context)) return;
          String emailAddress=widget._usernameController.text;
          String password=widget._passwordController.text;
          var _response = await MaLoginController.login(emailAddress, password);
          if (_response.error){
              maShowSnackBar(context: context, message: _response.message, error: true);
          }else{
            Navigator.pop(context);
          }
          
        
  }
  Future<bool> _handleSignWithgoogle() async {
          if(! await validate(context)) return false;
          
          response = await MaLoginController.signInWithGoogle();
         
          // isLoading(false);
          if (response!.error){
              maShowSnackBar(context: context, message: response?.message ?? '', error: true);
          }else{
            
          }
          return !response!.error;
        
  }
}*/


import 'package:flutter/material.dart';

class MALoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [Text(
          'login'
        ),]
      ),
    );
  }
}
