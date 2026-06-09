import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tommykcal/json/addmeal.dart';
import 'package:tommykcal/json/meal.dart';
import 'package:tommykcal/json/product.dart';

class ElModelo extends Model {
  final Map<DateTime, List<Meal>> _date2data = {};
  final List<Product> _products = [];

  Future<List<Meal>> getForDate(DateTime date) async {
    final data = _date2data[date];
    if (data == null) {
      final newData = await _loadForDate(date);
      _date2data.putIfAbsent(date, () => newData);
      return newData;
    }
    return data;
  }

  Future<List<Product>> get products async {
    if (_products.isEmpty) {
      final products = await _loadProducts();
      _products..clear()..addAll(products);
    }
    return _products;
  }

  Future<String> addForDate(DateTime date, int productId, int weight, String? comment) =>
      _addForDate(date, AddMeal(_extractDate(date), productId, weight, comment));

  Future<String> remove(DateTime date, int id) => _removeItem(date, id);

  Future<String> _addForDate(DateTime key, AddMeal item) async {
    final body = json.encode(item.toJson());
    print("POST http://mitrakoff.com:9090/kcal: $body");
    final pass = (await SharedPreferences.getInstance()).getString("_PASS");
    final response =
        await http.post(Uri.parse("http://mitrakoff.com:9090/kcal"), headers: {"Authorization": "bearer $pass"}, body: body);
    print("> ${response.body}");
    if (response.statusCode == 200) {
      _date2data.remove(key);
      notifyListeners();
      return response.body;
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  Future<String> _removeItem(DateTime key, int id) async {
    print("DELETE http://mitrakoff.com:9090/kcal/$id");
    final pass = (await SharedPreferences.getInstance()).getString("_PASS");
    final response = await http.delete(Uri.parse("http://mitrakoff.com:9090/kcal/$id"), headers: {"Authorization": "bearer $pass"});
    print("> ${response.body}");
    if (response.statusCode == 200) {
      _date2data.remove(key);
      notifyListeners();
      return response.body;
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  Future<List<Meal>> _loadForDate(DateTime date) async {
    final formatted = _extractDate(date);
    print("GET http://mitrakoff.com:9090/kcal/$formatted");
    final pass = (await SharedPreferences.getInstance()).getString("_PASS");
    final response =
        await http.get(Uri.parse("http://mitrakoff.com:9090/kcal/$formatted"), headers: {"Authorization": "bearer $pass"});
    print("> ${response.body}");
    if (response.statusCode == 200) {
      final list = json.decode(response.body) as List<dynamic>;
      final cast = list.map((e) => e as Map<String, dynamic>);
      return cast.map(Meal.fromJson).toList();
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  Future<List<Product>> _loadProducts() async {
    print("GET http://mitrakoff.com:9090/kcal/products");
    final pass = (await SharedPreferences.getInstance()).getString("_PASS");
    final response = await http.get(Uri.parse("http://mitrakoff.com:9090/kcal/products"), headers: {"Authorization": "bearer $pass"});
    print("> ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      return productList.map((js) => Product.fromJson(js)).toList();
    } else return Future.error("Error: ${response.statusCode}; ${response.body}");
  }

  String _extractDate(DateTime date) => "$date".split(" ").first; // "2023-12-12 00:00:00.000Z" => "2023-12-12"
}
