class ErrorResponse {
  int code;
  String message;

  ErrorResponse({this.code, this.message});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    message = json['message'];
  }
}