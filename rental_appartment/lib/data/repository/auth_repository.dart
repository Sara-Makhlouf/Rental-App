import '../models/user.dart';

class AuthRepository {
  final Map<String, User> _users = {
    "test@test.com": User(
      fullname: "Test User",
      address: "Demo Address",
      phone: "1234567890",
      password: "123456",
      verified: true,
    ),
  };

  Future<String> login(String phone, String pass) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!_users.containsKey(phone)) return "The User not found";
    if (_users[phone]!.password != pass) return "Wrong password";
    if (!_users[phone]!.verified) return "Account not verified";
    return "success";
  }

  Future<String> register(
    String fullname,
    String addr,
    String phone,
    String pass,
  ) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (_users.containsKey(phone)) {
      return "Phone Number already exists..Try in another Phone Number";
    }
    _users[phone] = User(
      fullname: fullname,
      address: addr,
      phone: phone,
      password: pass,
      verified: false,
    );
    return "success";
  }

  Future<String> sendReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!_users.containsKey(email)) return "Email not found";
    return "success";
  }

  Future<String> verify(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!_users.containsKey(email)) return "User not found";
    if (code != "123456") return "Invalid code digits";
    _users[email]!.verified = true;
    return "success";
  }
}
