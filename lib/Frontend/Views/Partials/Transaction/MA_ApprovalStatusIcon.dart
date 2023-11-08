import 'package:flutter/material.dart';
import 'package:x_money_manager/Utilities/MA_TransactionUtils.dart';
    
class MaApprovalStatusIcon extends StatelessWidget {
   MaApprovalStatusIcon({
    super.key,
    this.status,
  });

  String? status;
  get _status=> status  ?? '';
  @override
  Widget build(BuildContext context) {
    var _icon=Icons.do_not_disturb;
    var _color=Colors.black;
    var _config= MaStatusConfig.statusApprovalConfig0[_status];
    var _label=_status;
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