
import 'package:flutter/material.dart';

class outputField extends StatelessWidget {
   outputField({
    super.key,
    required this.value,
    required this.label,
     this.trailing,
     this.leading_icon,
     this.hide_border,
  });

  final String value;
  final String label;
   bool? hide_border=false;
   Widget? trailing=null;
   IconData? leading_icon=null;
   
  @override
  Widget build(BuildContext context) {
    var _leading= leading_icon == null ? null : Icon(leading_icon,size:40, color: Theme.of(context).colorScheme.primary);
    var _border = hide_border==true ? null : Border(bottom: BorderSide(
                                              color: Theme.of(context).colorScheme.onBackground,),);
     return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: _border,
        ),
        child:
        ListTile(
              leading:_leading,
              title: Text(label),
              subtitle: SelectableText(value),
              trailing:trailing,
            ),
      
      ),
    );
  }
}