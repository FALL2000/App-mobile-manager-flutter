class util {
  static  String toSString(Object? o){
   if(o==null) return '';
   return o.toString();

}
}
class MaCountry {
  final String name;
  final String? currencyCode;
  final String id;
  final String? iso;
  List<MaCity>? cities;

  MaCountry({
    required this.name,
    required this.id,
    this.iso,
    this.currencyCode,
    this.cities
  });
   MaCountry minimize(){

    return MaCountry(name: name, id: id,currencyCode:currencyCode, iso: iso);
  }
  factory MaCountry.fromJson(Map<Object?, Object?> json){

      List<MaCity> _cities = [];
      if(json['cities']!=null){
        for (var element in json['cities'] as List<dynamic>) {
          _cities.add(MaCity.fromJson(element));
        }
      }
      return MaCountry(
        name : util.toSString(json['name']),
        id : util.toSString(json['id']),
        iso: util.toSString(json['iso2']),
        currencyCode: util.toSString(json['currency']).isNotEmpty ?  util.toSString(json['currency']) :  util.toSString(json['currencyCode']) ,
        cities: _cities
      );



  } 

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
    'iso2': iso,
      };
  @override
  String toString() => "(currencyCode=$currencyCode,  name=$name, id=$id , iso2=$iso )";
}

class MaCity {
  final String name;
  final String id;

  MaCity({
    required this.name,
    required this.id
  });
  MaCity.fromJson(Map<Object?, Object?> json)
      : name = util.toSString(json['name']),
        id = util.toSString(json['id']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
  @override
  String toString() => "(name=$name, id=$id )";
}

