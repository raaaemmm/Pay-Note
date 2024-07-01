class UserModel {
  String? id;
  String? name;
  String? profilePhotoUrl;
  String? email;
  String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.profilePhotoUrl,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePhotoUrl': profilePhotoUrl,
      'email': email,
      'phone': phone,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map, String this.id):
    name = map['name'],
    profilePhotoUrl = map['profilePhotoUrl'],
    email = map['email'],
    phone = map['phone'];
}
