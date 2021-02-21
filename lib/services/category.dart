import 'dart:convert'; 
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../config/configuration.dart';

class CategoryService {
  Future<List<CategoryModel>> getCategories() async {
    var body = '''query {
                  categories {
                    _key
                    category
                    isActive
                  }
                }''';

    var response = await http.post(
      serverURL + '/api/graphql',
      body: json.encode({'query': body}),
      headers: {"Content-Type": "application/json"},
    ).catchError((error) {
      //print('error > $error');
      throw error;
    });

    //print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var jsonDataFinal = jsonData['data']['categories'];

      //print(jsonDataFinal.length);
      List<CategoryModel> objArray = [];
      // loop through the result
      if (jsonDataFinal != null && jsonDataFinal.length > 0) {
        for (var data in jsonDataFinal) {
          //print(data);
          CategoryModel obj = CategoryModel(
            key: data['_key'] as String,
            category: data['category'] as String,
            isActive: data['isActive'] as bool,
            error: null,
          );
          objArray.add(obj);
        }
        // end for in loop
        return objArray;
      } else {
        // no record found
        //print('GOT HERE');
        List<CategoryModel> objArray = [];
        CategoryModel obj = CategoryModel(
          key: null,
          category: null,
          isActive: null,
          error: 'No data',
        );
        objArray.add(obj);
        return objArray;
      }
    } else {
      List<CategoryModel> objArray = [];
      CategoryModel obj = CategoryModel(
        key: null,
        category: null,
        isActive: null,
        error: jsonDecode(response.body)['errors'][0]['message'],
      );
      objArray.add(obj);
      return objArray;
    }
  } // end get bonuses
}
