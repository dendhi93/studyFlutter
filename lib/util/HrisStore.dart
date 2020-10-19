import 'package:shared_preferences/shared_preferences.dart';

class HrisStore {
  final String usernameStore = "username";
  final String tokenStore = "token";

  //set value username
  Future<void> setAuthUsername(String un, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.usernameStore, un);
    prefs.setString(this.tokenStore, token);
  }

  //get value from shared preferences
  Future<String> getAuthUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String unStore;
    unStore = pref.getString(this.usernameStore) ?? "";
    return unStore;
  }
}