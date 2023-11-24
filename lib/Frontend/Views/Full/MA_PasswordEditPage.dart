import 'package:flutter/material.dart';
import 'package:x_money_manager/Data/localStorage/MA_LocalStore.dart';
import 'package:x_money_manager/Utilities/widgets/inputs.dart';

import '../../../Backend/MA_UserController.dart';
import '../../../Backend/MA_loginController.dart';
import '../../../Model/MA_User.dart';

class PasswordEditPage extends StatefulWidget {
  const PasswordEditPage({super.key});

  @override
  State<PasswordEditPage> createState() => _PasswordEditPageState();
}

class _PasswordEditPageState extends State<PasswordEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController currentPassControl = TextEditingController();
  TextEditingController newPassControl = TextEditingController();
  TextEditingController confirmPassControl = TextEditingController();
  String currentPassError = '';
  String newPassError = '';
  String confirmPassError = '';
  bool isCurrentPassVisible = false;
  bool isNewPassVisible = false;
  bool isConfirmPassVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password'),
      ),
      body: Center(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20,left: 16,right: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                MAInput(
                  controller: currentPassControl,
                  label: 'Current Password',
                  obscureText: !isCurrentPassVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isCurrentPassVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: (){
                      setState(() {
                        isCurrentPassVisible = !isCurrentPassVisible;
                      });
                    },
                  ),
                  validator: (value){
                    String val = value??'';
                    return val.trim().isEmpty?'This Field is required':null;
                  },
                ),
                SizedBox(height: 16.0),
                MAInput(
                  controller: newPassControl,
                  label: 'New Password',
                  obscureText: !isNewPassVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isNewPassVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: (){
                      setState(() {
                        isNewPassVisible = !isNewPassVisible;
                      });
                    },
                  ),
                  validator: (value){
                    String val = value??'';
                    return val.trim().isEmpty?'This Field is required':null;
                  },
                ),
                SizedBox(height: 16.0),
                MAInput(
                  controller: confirmPassControl,
                  label: 'Confirm New Password',
                  obscureText: !isConfirmPassVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPassVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: (){
                      setState(() {
                        isConfirmPassVisible = !isConfirmPassVisible;
                      });
                    },
                  ),
                  validator: (value){
                    String val = value??'';
                    return val.trim().isEmpty?'This Field is required':null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: ()async{
                      if (_formKey.currentState!.validate()) {
                        if (newPassControl.text == confirmPassControl.text) {
                          _showDialogSave(context);
                          MaUser? usr = await MaLocalStore.getStoredUser();
                          var _response = await MaLoginController.login(usr?.email as String, currentPassControl.text);
                          if (!_response.error) {
                            var res = await MaUserController.updateUserPassword(newPassControl.text);
                            if (!res.error) {
                               Navigator.pop(context);
                               _showDialog(context, 'Success', Container(
                                 height: 80,
                                 child: Center(
                                   child: Icon(Icons.check,size: 100,),
                                 ),
                               ));
                               currentPassControl.clear();
                               newPassControl.clear();
                               confirmPassControl.clear();
                            }else{
                              Navigator.pop(context);
                              _showDialog(context,'Error',Text('an error occurred while saving, please try again later'));
                            }
                          } else {
                            Navigator.pop(context);
                            _showDialog(context, 'Error', Text('Password change failed, check that your current password is correct'));
                          }
                        } else {
                          _showDialog(context, 'Error', Text('Confirmation password do not match with new password'));
                        }
                      }
                    },
                    child: Text('Save')
                )
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  void _showDialogSave(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('In Save...'),
          content: Container(height:100,child: Center(child: CircularProgressIndicator(),)),
          actions: [],
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
