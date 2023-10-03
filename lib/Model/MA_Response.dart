class MaResponse {
  bool error;
  String message;
  String? code;
  dynamic body;

  MaResponse({required this.error, required this.message, required this.body, this.code});
  static MaResponse successResponse({required  String message, dynamic  body , String? code=''}){
    var _successResponse=MaResponse(error: false, body: body, message:message , code:code);
    print(_successResponse.toString());

    return  _successResponse;
  }
  static MaResponse errorResponse({required String message, dynamic  body , String? code=''}){
    var _errResponse=MaResponse(error: true, body: body, message:message , code:code);
    print(_errResponse.toString());

    return  _errResponse;
  }
  @override
  String toString() => "(error=$error, message=$message , body=$body , code=$code )";
}