class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? avatar;
  final String? role;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.avatar,
    this.role,
    this.token,
  });

  bool get isAdmin => role == 'admin';

  factory User.fromJson(Map<String, dynamic> json, {String? token}) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      avatar: json['avatar']?.toString(),
      role: json['role']?.toString() ?? 'customer',
      token: token ?? json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'role': role,
      if (token != null) 'token': token,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? avatar,
    String? role,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }
}
