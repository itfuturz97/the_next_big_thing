import 'package:the_next_big_thing/utils/network/api_index.dart';
import 'package:the_next_big_thing/utils/network/api_manager.dart';

class AuthService {
  final ApiManager _apiManager = ApiManager();

  Future<dynamic> register(dynamic body) async => await _apiManager.post(APIIndex.register, body);

  Future<dynamic> login(dynamic body) async => await _apiManager.post(APIIndex.login, body);

  Future<dynamic> verifyMobile(dynamic body) async => await _apiManager.post(APIIndex.verify, body);
}
