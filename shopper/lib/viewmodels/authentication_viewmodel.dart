import 'package:flutter/material.dart';

import '../models/DBService.dart';
import '../models/account.dart';

class AuthViewModel extends ChangeNotifier {
  final DBService _dbService = DBService();
  late List<List> results;
  String passwordResetEmailSender = "shoppernotifications@gmail.com";

  checkInfo() async {
    results = await _dbService.getUserInfo(Account.user.email);

    if (results.isNotEmpty) {
      if (Account.user.checkPassword(results[0][5])) {
        Account.user.login();

        //update user info
        Account.user.userID = results[0][0];
        Account.user.firstName = results[0][1];
        Account.user.lastName = results[0][2];
      }
    }
  }

  Future<bool> saveInFo() async {
    final DBService _dbService = DBService();
    bool result = await _dbService.saveUserInfo(
        Account.user.email,
        Account.user.password,
        Account.user.firstName,
        Account.user.lastName,
        Account.user.salt);

    return result;
  }

  Future<bool> findUser(String email) async {
    final DBService _dbService = DBService();
    List<List> results = await _dbService.getUserInfo(email);
    return results.isNotEmpty;
  }

  Future<bool> resetPassword(String email, String password) async {
    final DBService _dbService = DBService();
    return await _dbService.resetUserPassword(email, password);
  }

  Future<bool> storeResetCode(String email, int code, String dateTime) async {
    final DBService _dbService = DBService();
    return await _dbService.storeResetCode(email, code, dateTime);
  }

  Future<int> checkResetCode(int code) async {
    final DBService _dbService = DBService();
    List<List> codeData = await _dbService.getResetCode(code);

    // Check Code Exists
    if (codeData.isEmpty) {
      return 1;
    }

    // Check Code has not been used
    if (codeData[0][4] == 1) {
      return 2;
    }

    // Check Code has not expired
    DateTime currentDateTime = DateTime.now();
    DateTime expirationDateTime = DateTime.parse(codeData[0][3]);
    if (currentDateTime.isAfter(expirationDateTime)) {
      return 2;
    }

    return 0;
  }

  Future<bool> setCodeUsed(int code) async {
    final DBService _dbService = DBService();
    return await _dbService.setCodeUsed(code);
  }

  Future<String> getApiKey(String api) async {
    final DBService _dbService = DBService();
    return await _dbService.getApiKey(api);
  }
}
