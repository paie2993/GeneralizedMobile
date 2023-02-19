import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../model/response/response.dart';
import '../model/model.dart';

class Remote {
  static const _days = 'http://10.0.2.2:2307/days';
  static const _transactions = 'http://10.0.2.2:2307/transactions';
  static const _transaction = 'http://10.0.2.2:2307/transaction';
  static const _entries = 'http://10.0.2.2:2307/entries';

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<List<DateModel>>> getDates() async {
    developer.log(
      'Fetching all dates from remote',
      name: 'Remote:getDates',
    );

    http.Response response;
    try {
      response = await http.get(Uri.parse(_days));
    } on Exception catch (e) {
      developer.log(
        'Exception fetching dates from remote',
        name: 'Remote:getDates',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to fetch dates from remote',
        name: 'Remote:getDates',
      );
      return Response(status: false, error: response.body);
    }

    final body = response.body;
    final dynamicList = jsonDecode(body) as List<dynamic>;

    List<DateModel> list;
    try {
      list = dynamicList.map((e) => DateModel.fromJson(e)).toList();
    } on Exception catch (e) {
      developer.log(
        'Failed to convert the remote dates into local model objects',
        name: 'Remote:getDates',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: list);
  }

  Future<Response<List<FinanceModel>>> getFinances(
    final String date,
  ) async {
    developer.log(
      'Fetching finances from remote',
      name: 'Remote:getFinances',
    );

    final address = '$_transactions/$date';
    http.Response response;
    try {
      response = await http.get(Uri.parse(address));
    } on Exception catch (e) {
      developer.log(
        'Exception fetching finances from remote',
        name: 'Remote:getFinances',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to fetch finances from remote',
        name: 'Remote:getFinances',
      );
      return Response(status: false, error: response.body);
    }

    final body = response.body;
    final dynamicList = jsonDecode(body) as List<dynamic>;

    List<FinanceModel> list;
    try {
      list = dynamicList.map((e) => FinanceModel.fromJson(e)).toList();
    } on Exception catch (e) {
      developer.log(
        'Failed to convert the remote finances into local model objects',
        name: 'Remote:getFinances',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: list);
  }

  Future<Response<List<FinanceModel>>> getFinanceEntries() async {
    developer.log(
      'Fetching finance entries from remote',
      name: 'Remote:getFinanceEntries',
    );

    final uri = Uri.parse(_entries);
    http.Response response;
    try {
      response = await http.get(uri);
    } on Exception catch (e) {
      developer.log(
        'Exception fetching finance entries from remote',
        name: 'Remote:getFinanceEntries',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to fetch finance entries from remote',
        name: 'Remote:getFinanceEntries',
      );
      return Response(status: false, error: response.body);
    }

    final body = response.body;
    final dynamicList = jsonDecode(body) as List<dynamic>;

    late final List<FinanceModel> list;
    try {
      list = dynamicList.map((e) => FinanceModel.fromJson(e)).toList();
    } on Exception catch (e) {
      developer.log(
        'Failed to convert the remote finance entries into local model objects',
        name: 'Remote:getFinanceEntries',
      );
      return Response(status: false, error: e.toString());
    }

    return Response(status: true, value: list);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<int>> addFinance(final FinanceModel data) async {
    developer.log(
      'Adding finance data to remote',
      name: 'Remote:addFinance',
    );
    final body = jsonEncode(data);
    developer.log(
      'Attempting to send following finance to remote: $body',
      name: 'Remote:addFinance',
    );

    late final Uri uri;
    try {
      uri = Uri.parse(_transaction);
    } on Exception catch (e) {
      developer.log(
        'Failed to parse the uri',
        name: 'Remote:addFinance',
      );
      return Response(status: false, error: e.toString());
    }

    late final http.Response response;
    try {
      response = await http.post(
        uri,
        body: body,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
    } on Exception catch (e) {
      developer.log(
        'Failed to add finance data remotely: request error',
        name: 'Remote:addFinance',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to add finance data remotely: server error',
        name: 'Remote:addFinance',
      );
      return Response(status: false, error: response.body);
    }
    final jsonBody = response.body;
    final jsonMap = jsonDecode(jsonBody);

    late final FinanceModel finance;
    try {
      finance = FinanceModel.fromJson(jsonMap);
    } on Exception catch (e) {
      developer.log(
        'Failed to convert remote data to local model',
        name: 'Remote:addFinance',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: finance.id);
  }

  Future<Response<bool>> deleteFinance(final int id) async {
    developer.log(
      'Attempting to delete finance remotely',
      name: 'Remote:deleteFinance',
    );
    late final Uri uri;
    try {
      uri = Uri.parse('$_transaction/$id');
    } on Exception catch (e) {
      developer.log(
        'Failed to parse uri for DELETE',
        name: 'Remote:deleteFinance',
      );
      return Response(status: false, error: e.toString());
    }

    late final http.Response response;
    try {
      response = await http.delete(uri).timeout(const Duration(seconds: 5));
    } on Exception catch (e) {
      developer.log(
        'Failed to delete finance remotely: request error',
        name: 'Remote:deleteFinance',
      );
      return Response(status: false, value: null, error: e.toString());
    }
    if (response.statusCode != 200) {
      developer.log(
        'Failed to delete finance remotely: server error',
        name: 'Remote:deleteFinance',
      );
      return Response(status: false, error: response.body);
    }
    return const Response(status: true, value: true);
  }
}
