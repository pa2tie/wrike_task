import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'bill.dart';

class BillService {
  static final _headers = {'Content-Type': 'application/json'};
  static const _billsStorageUrl = 'api/settings';

  final Client _http;

  BillService(this._http);

  Future<List<Bill>> getAll() async {
    
    try {
      final response = await _http.get(_billsStorageUrl);
      print(_extractData(response));
      final billsStorage = (_extractData(response) as List)
          .map((json) => Bill.fromJson(json))
          .toList();
      return billsStorage;
    } catch(e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];

  Exception _handleError(dynamic e) {
    print(e);
    return Exception('Server error; cause: $e');
  }

  Future<Bill> get(int nominal) async {
    try {
      final response = await _http.get('$_billsStorageUrl/$nominal');
      return Bill.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Bill> create(int nominal) async {
    try {
      final response = await _http.post(_billsStorageUrl,
          headers: _headers, body: json.encode({'nominal': nominal}));
          print(response);
      return Bill.fromJson(_extractData(response));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Bill> update(Bill bill) async {
    try {
      final url = '$_billsStorageUrl/${bill.nominal}';
      final response = 
          await _http.put(url, headers: _headers, body: json.encode(bill));
      return Bill.fromJson(_extractData(response));
    } catch(e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(int nominal) async {
    try {
      final url = '$_billsStorageUrl/$nominal';
      await _http.delete(url, headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
  }
}