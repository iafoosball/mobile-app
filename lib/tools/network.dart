import 'dart:io';
import 'dart:convert';

final serverstring = "192.38.56.114:9010/";

class Network{

  get(String location) async {
  var httpClient = new HttpClient();
  var uri = new Uri.http(
      serverstring+location, '/controller',);
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(Utf8Decoder()).join();
  return jsonDecode(responseBody);
}

  post(String location,Map<String,String> json) async {
  var httpClient = new HttpClient();
  var uri = new Uri.http(
      serverstring+location, '/controller',json);
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(Utf8Decoder()).join();
  return jsonDecode(responseBody);
}

}
