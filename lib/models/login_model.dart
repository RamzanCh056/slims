class LoginModel {
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  LoginModel({this.accessToken, this.tokenType, this.expiresIn});

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }
}