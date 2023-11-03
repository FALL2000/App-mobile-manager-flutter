import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../Data/localStorage/MA_LocalStore.dart';
import '../../../Data/states/zones_state.dart';
import '../../../Model/MA_User.dart';
import '../../../Model/MA_Zone.dart';
import '../../../Utilities/widgets/outputs.dart';
import '../Partials/MA_Error.dart';
import '../Partials/MA_Spinner.dart';

class ProfilePage extends StatelessWidget {
  final ZonesProvider zoneState = Get.put(ZonesProvider());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
           _buildProfileUser(context)
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
          var _user = snapshot.data as MaUser;
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
        onPressed: () {},
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
     String localisation = country =="" ? 'None' : country + '-'+ city;
     List<Map<String,dynamic>> userInfos = [
       {"element": name, "icon": Icons.person, "label":"Name", "key":"name", "isTextfield":true},
       {"element": localisation, "icon": Icons.location_city, "label":"Location", "key":"location", "isTextfield":false},
       {"element": User.email, "icon":Icons.email, "label":"Email Adress", "key":"email", "isTextfield":true},
       {"element":User.phone?? 'None', "icon":Icons.phone, "label":"Phone", "key":"phone", "isTextfield":true}
     ];
     return userInfos.map((e) =>
         outputField(
           hide_border: true,
           leading_icon: e['icon'],
           label: e['label'],
           value:e['element'],
           trailing:  e['key'] != 'name' ? IconButton(
             icon: Icon(Icons.edit, color:Theme.of(context).colorScheme.primary),
             onPressed: (){
               if(e['key'] == 'location'){
                 zoneState.init();
                 _showEditProfileBottomSheet(context,e);
               }else{
                 _showEditProfileBottomSheet(context,e);
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

  void _showEditProfileBottomSheet(BuildContext context, Map<String, dynamic> userInfos) {

    TextEditingController _textFieldController = TextEditingController(text: userInfos['element']);
    TextInputType typeInput = getTextInput(userInfos);
    List<String> country = zoneState.getCountries().map((e) => e.name).toList();
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
                  userInfos['isTextfield'] ? _builTextField(_textFieldController,typeInput) : DropdownButtonWidget(list: country,value: country.first,),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: (){},
                          child: Text('Enregistrer')
                      ),
                      TextButton(
                          onPressed: (){},
                          child: Text('Annuler')
                      )
                    ],
                  )
                ],
              ),
            ),
          );
      },
    );
  }

  Widget _builTextField(TextEditingController editControl, TextInputType typeInput){

    return  TextField(
      keyboardType: typeInput,
      controller: editControl,
      decoration:  InputDecoration(
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
    );
  }


  TextInputType getTextInput(Map<String, dynamic> userInfos){
     if(userInfos['key'] == 'phone')  return TextInputType.phone;
     if(userInfos['key'] == 'email')  return TextInputType.emailAddress;
     return TextInputType.text;
  }
}

class DropdownButtonWidget extends StatefulWidget {
  DropdownButtonWidget({super.key, required this.list, required this.value});
  List<String> list;
  String value;
  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState(list,value);
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  List<String> list;
  String dropdownValue;
  _DropdownButtonWidgetState(this.list, this.dropdownValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: DropdownButton<String>(
        isExpanded: true,
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        //style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.orange,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
