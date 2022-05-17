import 'package:dio/dio.dart';
import 'package:gifserachdemo/model/meme_list_model.dart';
import 'package:gifserachdemo/model/user_list_model.dart';

class NetworkUtils {
  final Dio dio = Dio();
  final String baseUrl = "https://api.imgflip.com/";

  /// get shipment list API call
  Future<MemeList?> getMemeList() async {
    try {
     dio.options.baseUrl = baseUrl;
      Response response = await dio.get(
        "get_memes",
        options: Options(headers: {
          "Accept": "application/json",
        }),
      );
      print("response:$response");
      return MemeList.fromJson(response.data);
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<UserList?> getUserList() async {
    try {
      dio.options.baseUrl = baseUrl;
      Response response = await dio.get(
        "https://randomuser.me/api/?results=15",
        options: Options(headers: {
          "Accept": "application/json",
        }),
      );
      print("response:$response");
      return UserList.fromJson(response.data);
    } on DioError catch (error) {
      print(error.response!.data);
    }
    return null;
  }
}
