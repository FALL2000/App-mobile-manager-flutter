// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
// import 'package:x_money_manager/utilities/colors.dart';
class MAInput extends StatelessWidget {
  TextInputType? keyboardType;
  Widget? suffix;
  Widget? suffixIcon;
  Widget? prefix;
  Widget? prefixIcon;
   MAInput({
    super.key,
    required this.controller,
    this.validator,
    this.label,
    this.obscureText,
    this.keyboardType,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
  });
  final String? label;
  final bool? obscureText;

  final TextEditingController controller;
  String? Function(String?)? validator ;
  get title=> label ?? '';
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme= Theme.of(context).colorScheme;
    return TextFormField(
      keyboardType:  keyboardType,
      obscureText: obscureText ?? false,
      controller: controller,
      // The validator receives the text that the user has entered.
      validator: validator ?? (value) {
        return null;
      },
      textAlignVertical: TextAlignVertical.center,
      // textAlign: TextAlign.center,
       maxLines: 1,
      style: const TextStyle(fontSize: 16),
      decoration:  InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                labelText: title,
                suffix: suffix,
                suffixIcon: suffixIcon,
                prefix: prefix,
                prefixIcon: prefixIcon,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide:  BorderSide(color: colorScheme.primary,)),
              ),
    );
  }
}
class MA_combobox extends StatelessWidget {
   MA_combobox({
    super.key,
    required this.items,
    this.value, 
    this.label,
    this.validator,
    required  this.onChanged,
  });

  final List<MA_option> items;
  final String? label;
  String? Function(dynamic)? validator ;
  String? Function(dynamic)? onChanged;
  String? value;
  get title=> label ?? '';


  List<DropdownMenuItem> buildItems(){
    print('@@@@@@@@@@@@@@@@@buildItems for $label >>in>>> $value');
    bool founded=false;
    var _value = value;
    var _default= DropdownMenuItem(value: '',child: Text(''),);
    var _items= items.map((option) {
        founded= founded || (option.value == _value);
        return DropdownMenuItem(value: option.value,child: Text(option.label),);
    }).toList();
    if(!founded){
      _items.insert(0, _default);
      value ='';
    }
    

    print('@@@@@@@@@@@@@@@@@buildItems >>out>>> $value');
    return _items;
  }
 



  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    var _items = buildItems();
    var dr= DropdownButtonFormField(
        items: _items,
        decoration: InputDecoration(
              labelText: title,
            ),
        alignment: AlignmentDirectional.bottomStart,
        value: value ?? '',
        onChanged: onChanged,
        validator: validator ,
      );

      // if (value!.isNotEmpty) {
      //   dr. = value;
      // }

      return dr;
  }
}

class MA_option{
  final String label;
  final String value;

  MA_option({
    required this.label,
    required this.value
  });
}


