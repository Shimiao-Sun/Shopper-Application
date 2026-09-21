import 'package:dbcrypt/dbcrypt.dart';

class Account {
  String firstName, lastName, email, password, salt;
  int loginState, userID;

  Account(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.loginState,
      required this.password,
      required this.salt,
      required this.userID});

  static int getLoginState(Account user) {
    return user.loginState;
  }

  void login() {
    loginState = 1;
  }

  void logout() {
    loginState = 0;
    firstName = "";
    lastName = "";
    email = "";
    userID = 0;
  }

  hashPassword() {
    DBCrypt dBcrypt = DBCrypt();
    salt = dBcrypt.gensalt();
    password = dBcrypt.hashpw(password, salt);
  }

  bool checkPassword(String givePassword) {
    DBCrypt dBcrypt = DBCrypt();
    if (dBcrypt.checkpw(password, givePassword)) {
      return true;
    }
    return false;
  }

  static Account user = Account(
      firstName: "",
      lastName: "",
      email: "",
      loginState: 0,
      password: "",
      salt: "",
      userID: 0);
}
