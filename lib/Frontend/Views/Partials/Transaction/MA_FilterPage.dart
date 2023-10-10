import 'package:flutter/material.dart';
    
class MaFilterPage extends StatelessWidget {

  const MaFilterPage({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              MAStatusOptionItem(label: 'ALL',value: 'ALL',),
              MAStatusOptionItem(label: 'Active',value: 'Active',),
              MAStatusOptionItem(label: 'Cancelled',value: 'cancelled',),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
  }
}

class MAStatusOptionItem extends StatefulWidget {
  final String label;
  final String value;

  const MAStatusOptionItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  State<MAStatusOptionItem> createState() => _MAStatusOptionItemState();
}

class _MAStatusOptionItemState extends State<MAStatusOptionItem> {
  bool _checked=false;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      // tileColor: Colors.red,
      title: Text(widget.label),
      value: _checked,
      onChanged:(bool? value) { 
        setState(() {
          _checked=!_checked;
        });
      },
    );
  }
}