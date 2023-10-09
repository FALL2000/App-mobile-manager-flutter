import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll.dart';
    
class MaList extends StatefulWidget {
  MaList({Key? key,required this.getDataResolver, this.searchText, this.reload,this.pageSize}) : super(key: key);
  final Future<List<dynamic>>  Function(int page) getDataResolver ;
  String? searchText='';
  bool? reload=false;
  bool get _reload => reload ?? false;
  int? pageSize=0;
  @override
  _MaListState createState() => _MaListState();
}

class _MaListState extends State<MaList> {
  Future<List<dynamic>> getNextPageData(int page) async {
    return await widget.getDataResolver(page);
  }

  List<dynamic> data = [];
  bool everyThingLoaded = false;

  @override
  void initState() {
    super.initState();

    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return  InfiniteScrollList(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: data.map((e) => ListItem(text: e)).toList(),
        onLoadingStart: (page) async {
          List<dynamic> newData = await getNextPageData(page);
          setState(() {
            data += newData;
            if (newData.isEmpty) {
              everyThingLoaded = true;
            }
          });
        },
        everythingLoaded: everyThingLoaded,
    );
  }

  Future<void> loadInitialData() async {
    data = await getNextPageData(0);
    setState(() {});
  }
}

class ListItem extends StatelessWidget {
  final String text;
  const ListItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.image),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}