import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:x_money_manager/Backend/MA_UserController.dart';
import 'package:x_money_manager/Backend/MA_loginController.dart';
//import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//import 'package:x_money_manager/Backend/MA_UserController.dart';

import '../../../Backend/MA_UserController.dart';
import '../../../Data/localStorage/MA_LocalStore.dart';
import '../../../Data/states/zones_state.dart';
import '../../../Model/MA_User.dart';
import '../../../Model/MA_Zone.dart';
import '../../../Utilities/widgets/outputs.dart';
import '../Partials/MA_Error.dart';
import '../Partials/MA_Spinner.dart';
import 'MA_PasswordEditPage.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ZonesProvider zoneState = Get.put(ZonesProvider());
  bool hasError = false;
  String emailTextError = '';
  String codeIso = '';
  String dropdownValueCity = '';
  String dropdownValueCountry = '';
  String currentPhone = '';
  bool isEnabled = false;
  List<MaCity> cityList = [];
  MaUser _user = MaUser(firstname: '', email: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
           _buildProfileUser(context),
           ElevatedButton(onPressed: () async{
                print('------------signOut onPressed---START-----------');
                await signOut();
                print('------------signOut onPressed---NAVIGATE START-----------');
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.popAndPushNamed(context, '/login');
                print('------------signOut onPressed---NAVIGATE END-----------');
                
                print('------------signOut onPressed---END-----------');
          }, child: Text('logout'))
        ],
      ),
    );
  }

  Widget _buildProfileUser(BuildContext context){
    return FutureBuilder<MaUser?>(
      future: MaLocalStore.getStoredUser(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<MaUser?> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          _user = snapshot.data as MaUser;
          child = _buildScrollView(_user, context);
        } else if (snapshot.hasError) {
          child = MaError(snapshot: snapshot ,);
        } else {
          child = MaSpinner();
        }
        return child;
      },
    );
  }

  Widget _buildScrollView(MaUser User, BuildContext context){
    Widget avatar = User.lastname == null ? _buildTitleAvatar(User.firstname, context) : _buildTitleAvatar(User.firstname, context, User.lastname);
    var childrens = [avatar];
    childrens.addAll(_buildListInfos(User, context));
    childrens.add(Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PasswordEditPage()),
          );
        },
        child: Text(
          "Edit Password",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary, fontSize: Theme.of(context).textTheme.bodySmall?.fontSize),
        ),
      ),
    ));
    return Expanded(
      child: CustomScrollView(
        key: new Key('scrollView'),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
                childrens
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitleAvatar(String firstName, BuildContext context, [String? lastName]){
    String titleName = lastName == null ? _buildtitleName(firstName): _buildtitleName(firstName, lastName);
    return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: ClipOval(child: Text(titleName, style: TextStyle(fontSize: 30, fontWeight: Theme.of(context).textTheme.headlineSmall?.fontWeight,color: Theme.of(context).colorScheme.onSecondary,),)),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 50,
                )
              ]
          ),
        )
    );
  }

  List<Widget> _buildListInfos(MaUser User, BuildContext context){
     String lastname = User.lastname?? '';
     String name = User.firstname + ' ' + lastname;
     String city = User.city?.name??"";
     String country = User.country?.name??"";
     String countryId = User.countryId??'';
     String cityId = User.cityId??'';
     String localisation = country =="" ? 'None' : country + '-'+ city;
     List<Map<String,dynamic>> userInfos = [
       {"element": name, "icon": Icons.person, "label":"Name", "key":"name", "isTextfield":true},
       {"element": localisation, "icon": Icons.location_city, "label":"Location", "key":"location", "isTextfield":false, "iso":User.country?.iso??""},
       {"element": User.email, "icon":Icons.email, "label":"Email Adress", "key":"email", "isTextfield":true},
       {"element":User.phone?? 'None', "icon":Icons.phone, "label":"Phone", "key":"phone", "isTextfield":true, "iso":User.country?.iso??""}
     ];
     return userInfos.map((e) =>
         outputField(
           hide_border: true,
           leading_icon: e['icon'],
           label: e['label'],
           value:e['element'],
           trailing:  e['key'] != 'name' ? IconButton(
             icon: Icon(Icons.edit, color:Theme.of(context).colorScheme.primary),
             onPressed: ()async{
               if(e['key'] == 'location'){
                 await zoneState.init();
                 setState(() {
                   dropdownValueCity = cityId;
                   dropdownValueCountry = countryId;
                   cityList = zoneState.getCountryCities(countryId);
                   codeIso = e['iso'];
                   currentPhone = User.phone??'';
                   isEnabled = false;
                   if(hasError)
                     hasError =false;
                 });
                 _showEditProfileBottomSheet(context,User, e, countryId);
               }else{
                   if(e['key'] == 'phone')
                     setState(() {
                       codeIso = e['iso'];
                     });
                   if(hasError)
                     setState((){
                       hasError = false;
                     });
                   _showEditProfileBottomSheet(context,User,e);
               }
             },
           ):null,
         )
     ).toList();
     /*return userInfos.map((e) =>
         ListTile(
           onTap: (){
             if(e['key'] != 'name'){
               _showEditProfileBottomSheet(context,e);
             }
           },
           leading: Icon(e['icon']),
           title: Text(e['label'], style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall?.fontSize),),
           subtitle: Text(e['element'], style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall?.fontSize),),
           trailing:  e['key'] != 'name' ? IconButton(
             icon: Icon(Icons.edit, color:Theme.of(context).colorScheme.primary),
             onPressed: (){
               _showEditProfileBottomSheet(context,e);
             },
           ):null,
         )
     ).toList();*/
  }

   String _buildtitleName(String firstName, [String? lastName]){
    try{
      if(lastName == null){
        return firstName.split(' ').length > 1 ? firstName.split(' ')[0][0].toUpperCase() + firstName.split(' ')[1][0].toUpperCase() : firstName[0].toUpperCase();
      }else{
        String fName = firstName.split(' ').length > 1 ? firstName.split(' ')[0].replaceFirst(firstName.split(' ')[0][0], firstName.split(' ')[0][0].toUpperCase()) : firstName.replaceFirst(firstName[0], firstName[0].toUpperCase());
        String lName = lastName.split(' ').length > 1 ? lastName.split(' ')[0].replaceFirst(lastName.split(' ')[0][0], lastName.split(' ')[0][0].toUpperCase()) : lastName.replaceFirst(lastName[0], lastName[0].toUpperCase());
        return fName[0].toUpperCase() + lName[0].toUpperCase();
      }
    }
    catch( e) {
      return '';
    }
  }

  void _showEditProfileBottomSheet(BuildContext context, MaUser User, Map<String, dynamic> userInfos, [String? countryId, String? phone]) {
    TextEditingController _textFieldController = userInfos['isTextfield'] ? TextEditingController(text: userInfos['element']):TextEditingController();
    TextInputType typeInput = getTextInput(userInfos);
    List<MaCountry> countryList = zoneState.getCountries();
    String valueCountry = countryId?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  userInfos['isTextfield'] ? _builTextField(_textFieldController,typeInput,userInfos) : _buildPicklistLocalisation(countryList,valueCountry,_textFieldController),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed:()async{
                            if(userInfos['isTextfield']){
                              if(hasError){
                                _showDialog(context,'Incorrect Value','You filled the field with incorrect value');
                              }else{
                               _showDialogSave(context);
                                dynamic data = userInfos['key'] == 'phone'? {'phone':_textFieldController.text}:{'email':_textFieldController.text};
                                var response = await MaUserController.updateUserInfo(data);
                                if(!response.error){
                                  if(userInfos['key'] == 'phone')
                                    User.phone = _textFieldController.text;
                                  if(userInfos['key'] == 'email')
                                    User.email = _textFieldController.text;
                                  await MaLocalStore.storeUser(User);
                                  setState(() {
                                    _user = User;
                                  });
                                  Navigator.pop(context);
                                }else{
                                  _showDialog(context,'Error Occured','an error occurred while saving, please try again later');
                                }
                                print('rrrrrrrrrrrrrrr${response}');
                                Navigator.pop(context);
                              }
                            }else{
                              if(hasError){
                                _showDialog(context,'Incorrect Value','You filled the field with incorrect value');
                              }else{
                                _showDialogSave(context);
                                dynamic data = valueCountry==dropdownValueCountry? {'city':dropdownValueCity,'country':dropdownValueCountry}:{'city':dropdownValueCity,'country':dropdownValueCountry,'phone':_textFieldController.text};
                                var response = await MaUserController.updateUserInfo(data);
                                if(!response.error){
                                  User.cityId = dropdownValueCity;
                                  User.countryId = dropdownValueCountry;
                                  User.country = zoneState.getCountry(dropdownValueCountry);
                                  User.city = zoneState.getCity(zoneState.getCountry(dropdownValueCountry), dropdownValueCity);
                                  if(valueCountry != dropdownValueCountry)
                                    User.phone = _textFieldController.text;
                                  await MaLocalStore.storeUser(User);
                                  setState(() {
                                    _user = User;
                                  });
                                  Navigator.pop(context);
                                }else{
                                  _showDialog(context,'Error Occured','an error occurred while saving, please try again later');
                                }
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text('Save')
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
      },
    );
  }

  Widget _builTextField(TextEditingController editControl, TextInputType typeInput,Map<String, dynamic> userInfos){
    return  (userInfos['key'] == 'phone') ?StatefulBuilder(
      builder: (context,setState) {
        return InternationalPhoneNumberInput(
          onInputChanged: (phoneNumber)async{
            if(codeIso != phoneNumber.isoCode){
              setState((){
                codeIso = phoneNumber.isoCode as String;
              });
            }
          },
          inputDecoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 1.0,
                ),
              )
          ),
          textFieldController: editControl,
          countries: [codeIso],
          initialValue: PhoneNumber(isoCode: codeIso, phoneNumber: editControl.text),
          onInputValidated: (bool value){
              //print("ffffffffffffffffffffffffff${value}");
            if(value){
              print('yesssssssssssssssssssssss');
              if(hasError){
                setState((){
                  hasError = false;
                });
              }
            }else{
              print('Noooooooooooooooooooooooo');
              if(!hasError){
                setState((){
                  hasError = true;
                });
              }
            }
          },
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          autoValidateMode: AutovalidateMode.onUserInteraction,
        );
      }
    ):
    StatefulBuilder(
      builder: (context,setState) {
        return TextField(
          keyboardType: typeInput,
          controller: editControl,
          decoration:  InputDecoration(
              errorText: hasError ? emailTextError:null,
              suffixText: '*',
              suffixStyle: TextStyle(color: Colors.red),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 1.0,
                ),
              )
          ),
          onChanged: (value){
             setState((){
               if(value.trim().isEmpty){
                 hasError = true;
                 emailTextError = 'This Field is required';
               }else{
                 RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                 if(!emailRegex.hasMatch(value)){
                   hasError = true;
                   emailTextError = 'Invalid adress mail';
                 }else{
                   hasError = false;
                 }
               }
             });
             print('dddddddddddddddddddd${hasError}');
             print('dddddddddddddddddddd${emailTextError}');
          },
        );
      }
    );
  }

  TextInputType getTextInput(Map<String, dynamic> userInfos){
     if(userInfos['key'] == 'phone')  return TextInputType.phone;
     if(userInfos['key'] == 'email')  return TextInputType.emailAddress;
     return TextInputType.text;
  }

  Widget _buildPicklistLocalisation(List<MaCountry> countryList, String countryId, TextEditingController editControl){
     return StatefulBuilder(
       builder: (context, setState) {
         return Column(
           children: [
             _dropdownButtonWidget(countryList,true,(value){
               setState((){
                 dropdownValueCountry = value;
                 cityList = zoneState.getCountryCities(value);
                 dropdownValueCity = cityList.first.id;
                 codeIso = zoneState.getCountry(value)?.iso as String;
                 isEnabled = value != countryId ? true:false;
               });
               if(value != countryId){
                 editControl.text = '';
               }else{
                 editControl.text = currentPhone;
               }
             }),
             _dropdownButtonWidget(cityList, false, (value){
               setState((){
                 dropdownValueCity = value;
               });
             }),
             InternationalPhoneNumberInput(
               onInputChanged: (phoneNumber)async{
                 if(codeIso != phoneNumber.isoCode){
                   setState((){
                     codeIso = phoneNumber.isoCode as String;
                   });
                 }
               },
               isEnabled: isEnabled,
               inputDecoration: InputDecoration(
                   border: UnderlineInputBorder(
                     borderSide: BorderSide(
                       color: Colors.grey,
                       width: 1.0,
                     ),
                   ),
                   focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(
                       color: Colors.orange,
                       width: 1.0,
                     ),
                   )
               ),
               textFieldController: editControl,
               countries: [codeIso],
               initialValue: PhoneNumber(isoCode: codeIso, phoneNumber: currentPhone),
               onInputValidated: (bool value){
                 //print("ffffffffffffffffffffffffff${value}");
                 if(value){
                   print('yesssssssssssssssssssssss');
                   if(hasError){
                     setState((){
                       hasError = false;
                     });
                   }
                 }else{
                   print('Noooooooooooooooooooooooo');
                   if(!hasError){
                     setState((){
                       hasError = true;
                     });
                   }
                 }
               },
               selectorConfig: SelectorConfig(
                 selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
               ),
               autoValidateMode: AutovalidateMode.onUserInteraction,
             )
           ],
         );
       }
     );
  }

  Widget _dropdownButtonWidget(List<dynamic> list, bool isCountry, void Function(dynamic) changeCallback){
    String dropdownValue = isCountry ? dropdownValueCountry : dropdownValueCity;
    return Container(
      width: 300,
      child: DropdownButton<dynamic>(
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        //style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.orange,
        ),
        onChanged: changeCallback,
        items: list.map<DropdownMenuItem<dynamic>>((dynamic element) {
          print('-------------------${element.name}');
          return DropdownMenuItem<dynamic>(
            value: element.id,
            child: Text(element.name),
          );
        }).toList(),
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

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
