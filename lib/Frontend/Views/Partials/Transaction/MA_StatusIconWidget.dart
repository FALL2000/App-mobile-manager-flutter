import 'package:flutter/material.dart';
import 'package:x_money_manager/Utilities/MA_TransactionUtils.dart';
    
class MAStatusIconWidget extends StatelessWidget {
   MAStatusIconWidget({
    super.key,
    this.status,
  });

  String? status;
  get _status=> status  ?? '';
  @override
  Widget build(BuildContext context) {
    var _icon=Icons.do_not_disturb;
    var _color=Colors.black;
    print('_status ---------------- $_status');
    var _config= MaStatusConfig.statusConfig0[_status];
     print(MaStatusConfig.statusConfig0);
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
}