class UsersModel {
  int? id;
  String? fullName;
  int? permissionRoleId;
  String? phoneNumber;
  String? oneCCode;
  String? bitrixId;
  String? region;
  String? username;
  String? password;
  int? permissionId;

  UsersModel(
      {this.id,
      this.fullName,
      this.permissionRoleId,
      this.phoneNumber,
      this.oneCCode,
      this.bitrixId,
      this.region,
      this.username,
      this.password,
      this.permissionId});

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    permissionRoleId = json['permission_role_id'];
    phoneNumber = json['phone_number'];
    oneCCode = json['one_c_code'];
    bitrixId = json['bitrix_id'];
    region = json['region'];
    username = json['username'];
    password = json['password'];
    permissionId = json['permission_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['permission_role_id'] = permissionRoleId;
    data['phone_number'] = phoneNumber;
    data['one_c_code'] = oneCCode;
    data['bitrix_id'] = bitrixId;
    data['region'] = region;
    data['username'] = username;
    data['password'] = password;
    data['permission_id'] = permissionId;
    return data;
  }
}
