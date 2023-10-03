// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';


class XItem {
  const XItem({
    required this.id,
    required this.name,
    required this.label,
    required this.icon,
     this.path,
  });

  final int id;
  final String name;
  final String label;
  final String? path;
  final IconData icon;

  String get route => '$path';

  @override
  String toString() => "$name (id=$id)";
}
const XItem _homeItem=XItem(
        id: 0,
        name: 'home',
        label: 'Home',
        path: '/',
        icon:  Icons.home,
      );
const XItem _transItem=XItem(
        id: 1,
        name: 'Transactions',
        label: 'Transactions',
        path: '/Transactions',
        icon:  Icons.share,
      );
const XItem _currItem=XItem(
        id: 2,
        name: 'Currencies',
        label: 'Currencies',
        path: '/Currencies',
        icon:  Icons.money,
      );
const XItem _settingsItem=XItem(
        id: 3,
        name: 'Settings',
        label: 'Settings',
        path: '/Settings',
        icon:  Icons.settings,
      
      );
class items {
  static XItem homeItem =_homeItem;
  static XItem transItem =_transItem;
  static XItem currItem =_currItem;
  static XItem settingsItem =_settingsItem;
}
class XItemsRepository {
  static XItem defaultItem(){
    return _homeItem;
  }
  static List<XItem> loadXItems(String? role) {
    const allXItems = <XItem>[
      _homeItem,
      _transItem,
      _currItem,
      _settingsItem,
      
    ];


    return allXItems;
  }
}

