class User {
  String fullname;
  String address;
  String phone;
  String password;
  bool verified;

  User({
    required this.fullname,
    required this.address,
    required this.phone,
    required this.password,
    this.verified = false,
  });
}
