// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  int? status;
  String? message;
  Response? response;

  LoginResponse({
    this.status,
    this.message,
    this.response,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        message: json["message"],
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "response": response?.toJson(),
      };
}

class Response {
  String? token;
  List<String>? access;

  Response({
    this.token,
    this.access,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        token: json["token"],
        access: json["access"] == null
            ? []
            : List<String>.from(json["access"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "access":
            access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
      };
}

// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

// import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String? emailId;
  String? password;

  LoginRequest({
    this.emailId,
    this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        emailId: json["emailId"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "emailId": emailId,
        "password": password,
      };
}
