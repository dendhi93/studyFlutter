import 'package:shared_preferences/shared_preferences.dart';

class HrisStore {
  final String usernameStore = "username";

  //set value username
  Future<void> setAuthUsername(String un) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.usernameStore, un);
  }

  //get value from shared preferences
  Future<String> getAuthUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String unStore;
    unStore = pref.getString(this.usernameStore) ?? "";
    return unStore;
  }
}