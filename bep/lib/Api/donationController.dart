import 'package:bep/Api/dioSetting.dart';
import 'package:bep/Util/toastMessage.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonationController {
  Dio dio = createDioClient();

  Future<int> donateToCategory(int id, String category, int point, Future<void> Function() getPoint) async {
    Map<String, dynamic> request = {
      'id': id,
      'category': category,
      'donationPoint': point,
    };
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      dio.options.headers['Authorization'] = 'Bearer $token';

      var response = await dio.post(
        '/main/donations/${id}',
        data: request,
        options: Options(contentType: Headers.jsonContentType),
      );

      int mPoint = int.parse(response.toString());
      prefs.setInt('userPoint', mPoint);
      getPoint();
      return mPoint;
    } catch (e) {
      print(e);
      showMoneyNotEnough();
      return -1;
    }
  }

  Future<List<CategoryState>?> getDonationStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      dio.options.headers['Authorization'] = 'Bearer $token';

      var response = await dio.get('/main/donations');
      List<dynamic> jsonList = response.data;
      List<CategoryState> categoriesState = jsonList.map((json) => CategoryState.fromJson(json)).toList();
      return categoriesState;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class CategoryState {
  final int id;
  final String category;
  final int donationPoint;

  CategoryState({
    required this.id,
    required this.category,
    required this.donationPoint,
  });

  factory CategoryState.fromJson(Map<String, dynamic> json) {
    return CategoryState(
      id: json['id'],
      category: json['category'],
      donationPoint: json['donationPoint'],
    );
  }
}
