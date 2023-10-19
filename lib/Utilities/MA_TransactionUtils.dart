import 'package:flutter/material.dart';

class MaStatusConfig {
   final String label;
    final String key;
    final IconData icon;
    final Color color;
    const  MaStatusConfig(this.key,  {required this.icon, required this.color, required this.label});

static const openConfig =MaStatusConfig('OPEN',
            icon:Icons.donut_large,
            color:Colors.blue,
            label:'Open',
          );
  static const appConfig = MaStatusConfig('IN APPROVAL',
      icon:Icons.circle,
      color:Colors.orange,
      label:'In approval',
    );
  static const progressConfig = MaStatusConfig('IN PROGRESS',
      icon:Icons.pending,
      color:Colors.indigo,
      label:'In progress',
    );
  static const approvedConfig = MaStatusConfig('APPROVED',
      icon:Icons.pending,
      color:Colors.indigo,
      label:'Approved',
    );
  static const cancelConfig = MaStatusConfig('CANCELED',
      icon:Icons.cancel,
      color:Colors.red,
      label:'Cancelled',
    );
  static const closeConfig = MaStatusConfig('CLOSED',
      icon:Icons.task_alt,
      color:Colors.green,
      label:'Done',
    );
  static final Map<String,MaStatusConfig>  statusConfig0={
    'OPEN': openConfig,
    'IN APPROVAL':appConfig,
    'IN PROGRESS':progressConfig,
    'APPROVED':approvedConfig,
    'CANCELED':cancelConfig,
    'CLOSED':closeConfig,
  };
  static final Map<String,MaStatusConfig>  statusApprovalConfig0={
    'OPEN': openConfig,
    'IN APPROVAL':appConfig,
    'IN PROGRESS':progressConfig,
    'APPROVED':approvedConfig,
    'CANCELED':cancelConfig,
    'REJECTED':cancelConfig,
    'CLOSED':closeConfig,
  };
  static final List<MaStatusConfig> filterStatues=[
    openConfig,approvedConfig,progressConfig,closeConfig,cancelConfig
  ];
}

