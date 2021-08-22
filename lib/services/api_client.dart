import 'dart:convert';

import 'package:http/http.dart' as http;
class ApiClient{
  final Uri currencyURL= Uri.http("free.currconv.com", "/api/v7/currencies",
      {"apiKey": "Api_KEY_HERE"
      });

  Future<List<String>?> getCurrencies()async{
    http.Response res = await http.get(currencyURL);
    if(res.statusCode == 200){

      var body = jsonDecode(res.body);
      var list = body["result"];
      List<String> currencies = (list.keys).toList();
      print(currencies);
      return currencies;
    }else{
     throw Exception("FAILED to connect to the API.");
    }
  }
  Future<double> getRate(String from,String to)async{
    final Uri rateUrl = Uri.https('free.currconv.com', '/api/v7/convert', {
      "apiKey": "Api_KEY_HERE",
      "q": "${from}_${to}",
      "compact":"ultra"
    });
    http.Response res = await http.get(rateUrl);
    if(res.statusCode == 200){
      var body =jsonDecode(res.body);
      return body["${from}_${to}"];
    }else{
      throw Exception("FAILED to convert.");
    }
  }
}