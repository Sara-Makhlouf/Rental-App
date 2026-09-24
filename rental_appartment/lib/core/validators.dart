class Validators {
  static bool isEmail(String email) {
    return RegExp(
      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
      caseSensitive: false,
    ).hasMatch(email);
  }

  static bool isPhone(String phone) {
    return RegExp(r'^\+?\d{9,15}$').hasMatch(phone);
  }

  static bool isPassword(String pass) {
    return pass.length >= 6;
  }
}
