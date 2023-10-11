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
    var _config= statusConfig0[_stauts];
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
  static const openConfig =statusConfig('OPEN',
            icon:Icons.donut_large,
            color:Colors.blue,
            label:'Open',
          );
  static const appConfig = statusConfig('IN APPROVAL',
      icon:Icons.circle,
      color:Colors.orange,
      label:'In approval',
    );
  static const progressConfig = statusConfig('IN PROGRESS',
      icon:Icons.pending,
      color:Colors.indigo,
      label:'in progress',
    );
  static const approvedConfig = statusConfig('APPROVED',
      icon:Icons.pending,
      color:Colors.indigo,
      label:'approved',
    );
  static const cancelConfig = statusConfig('CANCELED',
      icon:Icons.cancel,
      color:Colors.red,
      label:'canceled',
    );
  static const closeConfig = statusConfig('CLOSED',
      icon:Icons.task_alt,
      color:Colors.green,
      label:'done',
    );
  static final Map<String,statusConfig>  statusConfig0={
    'OPEN': openConfig,
    'IN APPROVAL':appConfig,
    'IN PROGRESS':progressConfig,
    'APPROVED':approvedConfig,
    'CANCELED':cancelConfig,
    'CLOSED':closeConfig,
  };
  static final List<statusConfig> filterStatues=[
    openConfig,progressConfig,closeConfig,cancelConfig
  ];
}
class statusConfig {
  final String label;
  final String key;
  final IconData icon;
  final Color color;
  const  statusConfig(this.key,  {required this.icon, required this.color, required this.label});
}