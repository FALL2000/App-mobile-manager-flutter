import 'package:flutter/material.dart';
import 'package:x_money_manager/model/MA_Transaction.dart';
    
class statusIconWidget extends StatelessWidget {
   statusIconWidget({
    super.key,
    this.status,
  });

  String? status;
  get _stauts=> status  ?? '';
  @override
  Widget build(BuildContext context) {
    var _icon=Icons.do_not_disturb;
    var _color=Colors.black;
    var _config= _statusConfig[_stauts];
    var _label='';
    if (_config!=null) {
        _icon= _config.icon;
        _color= _config.color;
        _label= _config.label;
    }
    
    return Column(
      children: [
        Icon(_icon, color: _color, size: 40,),
        Text(_label),
      ],
    );
  }

  Map<String,statusConfig>  _statusConfig={
    'OPEN': statusConfig(
            icon:Icons.donut_large,
            color:Colors.blue,
            label:'Open',
          ),
    'IN APPROVAL':statusConfig(
      icon:Icons.circle,
      color:Colors.orange,
      label:'In approval',
    ),
    'IN PROGRESS':statusConfig(
      icon:Icons.pending,
      color:Colors.indigo,
      label:'in progress',
    ),
    'APPROVED':statusConfig(
      icon:Icons.pending,
      color:Colors.indigo,
      label:'approved',
    ),
    'CANCELED':statusConfig(
      icon:Icons.cancel,
      color:Colors.red,
      label:'canceled',
    ),
    'CLOSED':statusConfig(
      icon:Icons.task_alt,
      color:Colors.green,
      label:'done',
    ),
  };
}
class statusConfig {
  final String label;
  final IconData icon;
  final Color color;
  const  statusConfig( {required this.icon, required this.color, required this.label});
}