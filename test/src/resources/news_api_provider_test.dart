import 'package:flutter_news/src/models/item_model.dart';
import 'package:flutter_news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  // Description of the test that we want to write.
  final String fetchTopIdDescription =
      'Fetch top ids that returns a list of ids';
  final String fetchItemDescription = 'Fetch item that will return a ItemModel';

  // Test for fetchTopIds().
  test(fetchTopIdDescription, () async {
    //Setup of test case
    // Example : int sum = 4 + 5;
    //Expectation
    //Example: expect(sum, 9);

    final NewsApiProvider apiProvider = NewsApiProvider();

    apiProvider.client = MockClient((Request request) async {
      /*
     * This function will invoke at any time our code trys to create a http request.
     * So whatever we return from this function will be, what our code thinks that its getting
     * back from that outsider api. 
     * In this case MockClient function 
     * We are returning some amount of jason data from this function.
     * For that we will create fake list of ids.
     * MockClient() function return Future<Response> object(Response object) but json is string so we cannot
     * return json. We have to convert into Future.
     * 200 is status code. Which means everything is ok and request is successful.
     * Just creating MockClient does not do anything. This will not autometically intercept 
     * request that we made. So we have to do manually. We have to replace NewsApiProvider
     * client by this mock client to run this function. That is why we have used client insted of get
     * and declared client as instance variable in NewsApiProvider insted of using get method directly.
     * We have override NewsApiProvider client by this mockClient.
     */
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final List ids = await apiProvider.fetchTopIds();

    expect(ids, [1, 2, 3, 4]);
  });

  // Test for fetch item.
  test(fetchItemDescription, () async {
    final NewsApiProvider apiProvider = NewsApiProvider();
    apiProvider.client = MockClient((Request request) async {
      // Map is like a javascript object or a model class in dart
      // So we will return map from this response
      final Map<String, dynamic> jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });

    final ItemModel item = await apiProvider.fetchItem(999);

    expect(item.id, 123);
  });
}
