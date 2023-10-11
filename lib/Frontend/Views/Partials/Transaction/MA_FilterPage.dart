import 'package:flutter/material.dart';
import 'package:x_money_manager/Frontend/Views/Partials/Transaction/statusIconWidget.dart';

import 'package:x_money_manager/Frontend/Controllers/MA_TransactionsGetxCtrl.dart';

import 'package:get/get.dart';
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



class MaFilterIcon extends StatelessWidget {
  static final  controller = Get.put(TransactionsProvider());
  
  const MaFilterIcon({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
            icon: const Icon(
              Icons.filter_list,
              semanticLabel: 'search',
            ),
            onPressed: () {
                var widgets=statusIconWidget.filterStatues.map((e)  {

                  print(e.label);
                  return ListTile(
                      trailing: Icon(e.icon),
                      title: Text(e.label),
                      onTap: ()async {
                        controller.updateStatusSet(e.key);
                        Navigator.pop(context);
                      },
                  );
                }).toList();
                // Get.bottomSheet(
                //   SizedBox(
                //       height: 250,
                //       child: Column(
                //                 children: widgets /*<Widget>[
                //                   MAStatusOptionItem(label: 'ALL',value: 'ALL',),
                //                   MAStatusOptionItem(label: 'Active',value: 'Active',),
                //                   MAStatusOptionItem(label: 'Cancelled',value: 'cancelled',),
                //                 ]*/,
                //       ),
                //     )
                // );
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 250,
                      child: Column(
                                children: widgets /*<Widget>[
                                  MAStatusOptionItem(label: 'ALL',value: 'ALL',),
                                  MAStatusOptionItem(label: 'Active',value: 'Active',),
                                  MAStatusOptionItem(label: 'Cancelled',value: 'cancelled',),
                                ]*/,
                      ),
                    );
                  },
                );
        

              // showDialog<void>(
              //   context: context,
              //   barrierDismissible: false, // user must tap button!
              //   builder: (BuildContext context) {
              //     return MaFilterPage();
              //   },
              // );
            },
          );
  }
}

