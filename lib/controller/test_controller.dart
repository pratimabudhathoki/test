import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:text_applicaiton/model/items_model.dart';

class ProductController extends GetxController {
  RxBool isDataLoading = false.obs;
  List<ItemsModel> itemsList = [];

  Future<void> getAllProducts() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/todos");
    try {
      isDataLoading(true);
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        isDataLoading(false);
        List<dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        itemsList =
            jsonResponse.map((item) => ItemsModel.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load data");
      }
    } finally {
      isDataLoading(false);
    }
  }

  Future<void> removeProduct(ItemsModel item) async {
    try {
      itemsList.remove(item);

      var url =
          Uri.parse("https://jsonplaceholder.typicode.com/todos/${item.id}");
      await http.delete(url);
    } catch (e) {
      print('Error removing product: $e');
    }
  }

  Future<void> updateCompletion(ItemsModel item, bool completed) async {
    try {
      item.completed = completed;

      var url =
          Uri.parse("https://jsonplaceholder.typicode.com/todos/${item.id}");
      await http.put(url, body: jsonEncode({"completed": completed}));
    } catch (e) {
      print('Error updating completion status: $e');
    }
  }
}
