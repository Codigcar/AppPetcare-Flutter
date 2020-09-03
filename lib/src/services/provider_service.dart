import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:petcare/src/models/provider_model.dart';

class ProviderService {
  final String _url = 'http://10.0.2.2:8081/api';

  Future<bool> registerProvider(ProviderModel provider, int businessProfileId) async {
    final url = '$_url/business/'+ businessProfileId.toString()+'/providers';
    Map<String, String> headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final resp = await http.post( url, headers: headers, body: providerModelToJson(provider));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    if( resp.statusCode == 200 ){
      return true;
    } else {
      return false;
    }
  }
}