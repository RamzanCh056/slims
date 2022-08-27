class MessagesModel {
  String? id;
  String? phone;
  String? msg;
  bool? isSelected;

  MessagesModel({this.id, this.phone, this.msg, this.isSelected = false});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    msg = json['msg'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['msg'] = this.msg;
    isSelected = false;
    return data;
  }
}
