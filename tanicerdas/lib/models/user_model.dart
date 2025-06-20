class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String region;
  final String role;
  final String? fotoProfil;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.region,
    required this.role,
    this.fotoProfil,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      phone: map['phone'],
      region: map['region'],
      role: map['role'],
      fotoProfil: map['fotoProfil'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'region': region,
      'role': role,
      'fotoProfil': fotoProfil,
    };
  }
}
