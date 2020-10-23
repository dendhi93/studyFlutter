import 'package:shared_preferences/shared_preferences.dart';

class HrisStore {
  final String usernameStore = "username";
  final String tokenStore = "token";
  final String userIDStore = "user_id";

  //set value username
  Future<void> setAuthUsername(String un, String token, String userID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.usernameStore, un);
    prefs.setString(this.tokenStore, token);
    prefs.setString(this.userIDStore, userID);
  }

  //get value from shared preferences
  Future<String> getAuthUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String unStore;
    unStore = pref.getString(this.usernameStore) ?? "";
    return unStore;
  }

  Future<String> getAuthUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String uIdStore;
    uIdStore = pref.getString(this.userIDStore) ?? "";
    return uIdStore;
  }

  Future<String> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String userToken;
    userToken = pref.getString(this.tokenStore) ?? "";
    return userToken;
  }
}