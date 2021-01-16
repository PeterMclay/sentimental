import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);

  Future getData() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
