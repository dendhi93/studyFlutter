import 'package:absent_hris/util/ConstantsVar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HrisStore {
  final String usernameStore = "username";
  final String tokenStore = "token";
  final String userIDStore = "user_id";
  final String userLevelStore = "user_level";
  final String userTypeStore = "user_type";

  //set value username
  Future<void> setAuthUsername(String un, String token, String userID, String userLevel,String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.usernameStore, un);
    prefs.setString(this.tokenStore, token);
    prefs.setString(this.userIDStore, userID);
    prefs.setString(this.userLevelStore, userLevel);
    prefs.setString(this.userTypeStore, userType);
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

  Future<String> getAuthUserLevelId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String uLevelIdStore;
    uLevelIdStore = pref.getString(this.userLevelStore) ?? "";
    return uLevelIdStore;
  }

  Future<String> getAuthUserLevelType() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String uTypeStore;
    uTypeStore = pref.getString(this.userTypeStore) ?? "";
    return uTypeStore;
  }

  Future<String> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String userToken;
    userToken = pref.getString(this.tokenStore) ?? "";
    return userToken;
  }

  Future<bool>removeAllValues() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    return true;
  }

  Future<bool>removeParticularPref(int prefType) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if(prefType == ConstanstVar.unPrefType){
      pref.remove(usernameStore);
      return true;
    }else if(prefType == ConstanstVar.uIdPrefType){
      pref.remove(userIDStore);
      return true;
    }else{
      pref.remove(tokenStore);
      return true;
    }
  }
}