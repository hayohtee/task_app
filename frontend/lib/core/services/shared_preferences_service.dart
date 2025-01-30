import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  void setAccessToken(String accessToken) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('x-access-token', accessToken);
  }

  void setRefreshToken(String refreshToken) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('x-refresh-token', refreshToken);
  }

  Future<String?> getAccessToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('x-access-token');
  }

  Future<String?> getRefreshToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('x-refresh-token');
  }
}
