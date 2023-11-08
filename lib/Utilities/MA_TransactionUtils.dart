import 'package:flutter/material.dart';

class MaStatusConfig {
   final String label;
    final String key;
    final IconData icon;
    final Color color;
    const  MaStatusConfig(this.key,  {required this.icon, required this.color, required this.label});
@override
  String toString() => "(label=$label,key=$key,icon=$icon )";
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
  static const queudConfig = MaStatusConfig('QUEUED',
      icon:Icons.warning,
      color:Colors.orange,
      label:'Queued',
    );
  static const closeConfig = MaStatusConfig('CLOSED',
      icon:Icons.task_alt,
      color:Colors.green,
      label:'Done',
    );
  static const collectedConfig = MaStatusConfig('COLLECTED',
    icon:Icons.task_alt,
    color:Color.fromARGB(255, 143, 204, 145),
    label:'Collected',
  );
  static const stoppedConfig = MaStatusConfig('STOPPED',
      icon:Icons.cancel,
      color:Color.fromARGB(255, 184, 244, 54),
      label:'Paused',
    );
  static final Map<String,MaStatusConfig>  statusConfig0={
    'OPEN': openConfig,
    'IN APPROVAL':appConfig,
    'IN PROGRESS':progressConfig,
    'APPROVED':approvedConfig,
    'CANCELED':cancelConfig,
    'CLOSED':closeConfig,
    'QUEUED':queudConfig,
  };
  static final Map<String,MaStatusConfig>  statusApprovalConfig0={
    'OPEN': openConfig,
    'IN APPROVAL':appConfig,
    'IN PROGRESS':progressConfig,
    'APPROVED':approvedConfig,
    'CANCELED':cancelConfig,
    'REJECTED':cancelConfig,
    'CLOSED':closeConfig,
    'QUEUED':queudConfig,
    'STOPPED': stoppedConfig,
    'COLLECTED': collectedConfig,
  };
  static final List<MaStatusConfig> filterStatues=[
    openConfig,approvedConfig,progressConfig,closeConfig,cancelConfig
  ];
}

