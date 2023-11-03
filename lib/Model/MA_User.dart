
import 'dart:convert';

import 'MA_Zone.dart';
enum Gender {
  male('MALE'),
  female('FEMALE');

  final String keyValue;
  const  Gender( this.keyValue);
  static Gender? assignGender(String key){
    try {
      return Gender.values.firstWhere((element) => element.keyValue==key);
    } catch (e) {
      print(e);
    }


  }
}
enum Role {
  client('CLIENT'),
  manager('MANAGER'),
  admin('ADMIN');

  final String keyValue;
  const  Role( this.keyValue);
  static Role? assignRole(String key){
    try {
      return Role.values.firstWhere((element) => element.keyValue==key);
    } catch (e) {
      print(e);
    }
  }
}

class MaUser {
  String firstname;
  String? lastname;
  String? phone;
  Role? role;
  String? password;
  Gender? gender;
  String email;
  String? userId;
  String? createdDate;
  String? countryId;
  MaCountry? country;
  MaCity? city;
  String? cityId;
  String? workload;
  String? flag;
  Map<String, dynamic>? workStatus;

  String get fullname=> '${firstname}${ lastname!.isNotEmpty ? ' '+lastname! : ''}';
  String get workload0=> workload?.isNotEmpty ??false ? '$workload' : '0';
  String get initial{
    String titleName = '';
    try {

      List<String> _parts=  fullname.split(' ');
      for (var i = 0; i < _parts.length; i++) {
        String word = _parts[i];
        titleName=titleName+word.trim()[0];
        if (i == 1) break;
      }
    } catch (e) {
      titleName='US';
    }
    return titleName.toUpperCase();
  }

  MaUser({ required this.firstname, this.lastname, this.phone, this.gender, required this.email,
    this.password, this.userId, this.createdDate, this.countryId,
    this.role,
    this.workload,this.flag,
    this.country,this.city,
    this.cityId, this.workStatus});


  factory MaUser.BuilfromJson(Map<Object?, Object?> json){

    print('@@@@@@@@@@@@++++++');
    print(json);
    Map<Object?, Object?> zone= jsonDecode( jsonEncode(json['cityObj']??{}));
    Map<String, dynamic>? workStatus = json['workStatus']!=null ? jsonDecode( jsonEncode(json['workStatus'])) : null;
    print('-----------------flag');
    print(util.toSString(jsonDecode( jsonEncode(zone['country']??{}))['flag']));
    var user= MaUser(
      firstname: util.toSString(json['firstname']),
      lastname: util.toSString(json['lastname']),
      phone: util.toSString(json['phone']),
      email: util.toSString(json['email']),
      userId: util.toSString(json['userId']),
      workload: util.toSString(json['workload']),
      workStatus: workStatus,
      createdDate: util.toSString(json['createdDate']),
      countryId: json['country'] != null ? util.toSString(json['country']) : util.toSString(jsonDecode( jsonEncode(zone['country']??{}))['id']),
      cityId: util.toSString(zone['id']),
      flag: util.toSString(jsonDecode( jsonEncode(zone['country']??{}))['flag']),
      gender: Gender.assignGender(util.toSString(json['gender'])),
      role: Role.assignRole(util.toSString(json['role'])),

    );
    user.city=MaCity(name: util.toSString(zone['name']), id: user.cityId ?? '');
    user.country= MaCountry(name: util.toSString(jsonDecode( jsonEncode(zone['country']??{}))['name']), id: user.countryId ?? '');
    return user;





  }

  factory MaUser.fromJson(Map<Object?, Object?> json){
    print('@@@@@@@@@@@@++++++');
    print(json);
    Map<Object?, Object?> zone= jsonDecode( jsonEncode(json['cityObj']??{}));
    Map<Object?, Object?> _city= jsonDecode( jsonEncode(json['city']??{}));
    return MaUser(
    firstname: util.toSString(json['firstname']),
    lastname: util.toSString(json['lastname']),
    phone: util.toSString(json['phone']),
    email: util.toSString(json['email']),
    userId: util.toSString(json['userId']),
    flag: util.toSString(json['flag']),
    workload: util.toSString(json['workload']),
    createdDate: util.toSString(json['createdDate']),
    countryId: util.toSString(json['countryId']),
    cityId: util.toSString(json['cityId']),
    country:  MaCountry.fromJson(jsonDecode( jsonEncode(json['country']??{}))),
    city: MaCity.fromJson(_city),
    gender: Gender.assignGender(util.toSString(json['gender'])),
    role: Role.assignRole(util.toSString(json['role'])),
    );





  }


  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
    'phone': phone,
    'password': password,
    'gender': gender?.keyValue,
    'email': email,
    'userId': userId,
    'createdDate': createdDate,
    'countryId': countryId,
    'cityId': cityId,
    'country': country?.toJson(),
    'city': city?.toJson(),
    'flag': flag,
    'workload': workload,
  };

  Map<String, dynamic> toSave(){
    var input= {
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      // 'password': password,
      'gender': gender?.keyValue,
      'email': email,
      'userId': userId,
      // 'createdDate': createdDate,
      'country': countryId,
      'city': cityId,
    };

    return input;
  }

}