import 'package:flutter/material.dart';
    
class MaExpansionPanelList extends StatefulWidget {
  const MaExpansionPanelList({
    super.key,
    required this.children,
  });
  final List<MAExpansionPanel> children;

  @override
  State<MaExpansionPanelList> createState() => MaExpansionPanelListState();
}

class MAExpansionPanel {
  final Widget Function(BuildContext, bool) headerBuilder;
  final Widget body;
  MAExpansionPanel({
    required this.headerBuilder,
    required this.body,
  });
}

class MaExpansionPanelListState extends State<MaExpansionPanelList> {
  final _openend = {};

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandIconColor: Colors.red,
      dividerColor: Colors.green,
      expansionCallback: (panelIndex, isExpanded) {
        var update = {panelIndex: isExpanded};
        _openend.addAll(update);
        setState(() {});
      },
      children: widget.children.asMap().entries.map((e) {
        MAExpansionPanel panel = e.value;
        return ExpansionPanel(
            canTapOnHeader: true,
            // backgroundColor: Colors.amberAccent,
            isExpanded: !_openend.containsKey(e.key) || _openend[e.key] == true,
            body: panel.body,
            headerBuilder: panel.headerBuilder);
      }).toList(),
    );
  }
}
