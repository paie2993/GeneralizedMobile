import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../model/response/response.dart';
import '../model/model.dart';

class Remote {
  static const _port = '2310';
  static const _baseAddress = 'http://10.0.2.2:$_port';

  static const _getSupports = '$_baseAddress/...';
  static const _getEntities = '$_baseAddress/...';
  static const _post = '$_baseAddress/...';
  static const _delete = '$_baseAddress/...';

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<List<SupportModel>>> getSupports() async {
    developer.log(
      'Fetching all supports from remote',
      name: 'Remote:getSupports',
    );

    http.Response response;
    try {
      response = await http.get(Uri.parse(_getSupports));
    } on Exception catch (e) {
      developer.log(
        'Exception fetching supports from remote',
        name: 'Remote:getSupports',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to fetch supports from remote',
        name: 'Remote:getSupports',
      );
      return Response(status: false, error: response.body);
    }

    final body = response.body;
    final dynamicList = jsonDecode(body) as List<dynamic>;

    late final List<SupportModel> list;
    try {
      list = dynamicList.map((e) => SupportModel.fromJson(e)).toList();
    } on Exception catch (e) {
      developer.log(
        'Failed to convert the remote supports into local model objects',
        name: 'Remote:getSupports',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: list);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<List<EntityModel>>> getEntities() async {
    developer.log(
      'Fetching entities from remote',
      name: 'Remote:getEntities',
    );

    final address = '$_getEntities/$field';
    http.Response response;
    try {
      response = await http.get(Uri.parse(address));
    } on Exception catch (e) {
      developer.log(
        'Exception fetching entities from remote',
        name: 'Remote:getEntities',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to fetch entities from remote',
        name: 'Remote:getEntities',
      );
      return Response(status: false, error: response.body);
    }

    final body = response.body;
    final dynamicList = jsonDecode(body) as List<dynamic>;

    late final List<EntityModel> list;
    try {
      list = dynamicList.map((e) => EntityModel.fromJson(e)).toList();
    } on Exception catch (e) {
      developer.log(
        'Failed to convert the remote entities into local model objects',
        name: 'Remote:getEntities',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: list);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<List<EntityModel>>> getEntitiesByField(
    final Field field,
  ) async {
    developer.log(
      'Fetching entities from remote',
      name: 'Remote:getEntities',
    );

    final address = '$_getEntities/$field';
    http.Response response;
    try {
      response = await http.get(Uri.parse(address));
    } on Exception catch (e) {
      developer.log(
        'Exception fetching entities from remote',
        name: 'Remote:getEntities',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to fetch entities from remote',
        name: 'Remote:getEntities',
      );
      return Response(status: false, error: response.body);
    }

    final body = response.body;
    final dynamicList = jsonDecode(body) as List<dynamic>;

    late final List<EntityModel> list;
    try {
      list = dynamicList.map((e) => EntityModel.fromJson(e)).toList();
    } on Exception catch (e) {
      developer.log(
        'Failed to convert the remote entities into local model objects',
        name: 'Remote:getEntities',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: list);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<EntityModel>> getEntity(
    final Field field,
  ) async {
    developer.log(
      'Fetching entity from remote',
      name: 'Remote:getEntity',
    );

    final address = '$_getEntities/$field';
    http.Response response;
    try {
      response = await http
          .get(Uri.parse(address))
          .timeout(const Duration(seconds: 5));
    } on Exception catch (e) {
      developer.log(
        'Exception fetching entity from remote',
        name: 'Remote:getEntity',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to fetch entity from remote',
        name: 'Remote:getEntity',
      );
      return Response(status: false, error: response.body);
    }

    final body = response.body;
    final dynamicMap = jsonDecode(body);

    late final EntityModel entity;
    try {
      entity = EntityModel.fromJson(dynamicMap);
    } on Exception catch (e) {
      developer.log(
        'Failed to convert the remote entity into local model objects',
        name: 'Remote:getEntity',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: entity);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<int>> addEntity(final EntityModel data) async {
    developer.log(
      'Adding entity data to remote',
      name: 'Remote:addEntity',
    );
    final body = jsonEncode(data);
    developer.log(
      'Attempting to send following entity to remote: $body',
      name: 'Remote:addEntity',
    );

    late final Uri uri;
    try {
      uri = Uri.parse(_post);
    } on Exception catch (e) {
      developer.log(
        'Failed to parse the uri',
        name: 'Remote:addEntity',
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
        'Failed to add entity data remotely: request error',
        name: 'Remote:addEntity',
      );
      return Response(status: false, error: e.toString());
    }

    if (response.statusCode != 200) {
      developer.log(
        'Failed to add entity data remotely: server error',
        name: 'Remote:addEntity',
      );
      return Response(status: false, error: response.body);
    }
    final jsonBody = response.body;
    final jsonMap = jsonDecode(jsonBody);

    late final EntityModel entity;
    try {
      entity = EntityModel.fromJson(jsonMap);
    } on Exception catch (e) {
      developer.log(
        'Failed to convert remote entity data to local model',
        name: 'Remote:addEntity',
      );
      return Response(status: false, error: e.toString());
    }
    return Response(status: true, value: entity.id);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<bool>> deleteEntity(final Field field) async {
    developer.log(
      'Attempting to delete entity remotely',
      name: 'Remote:deleteEntity',
    );
    late final Uri uri;
    try {
      uri = Uri.parse('$_delete/$field');
    } on Exception catch (e) {
      developer.log(
        'Failed to parse uri for DELETE',
        name: 'Remote:deleteEntity',
      );
      return Response(status: false, error: e.toString());
    }

    late final http.Response response;
    try {
      response = await http.delete(uri).timeout(const Duration(seconds: 5));
    } on Exception catch (e) {
      developer.log(
        'Failed to delete entity remotely: request error',
        name: 'Remote:deleteEntity',
      );
      return Response(status: false, value: null, error: e.toString());
    }
    if (response.statusCode != 200) {
      developer.log(
        'Failed to delete entity remotely: server error',
        name: 'Remote:deleteEntity',
      );
      return Response(status: false, error: response.body);
    }
    return const Response(status: true, value: true);
  }
}
