import 'dart:async';
import 'dart:convert';

import 'package:base/local/localdb.dart';
import 'package:base/model/model.dart';
import 'package:base/remote/remote.dart';
import 'package:drift/drift.dart';
import 'dart:developer' as developer;

import '../model/response/response.dart';
import '../remote/connection_manager.dart';

class Repo {
  Repo({
    required local,
    required remote,
    required connectionManager,
  }) {
    _local = local;
    _remote = remote;
    _connectionManager = connectionManager;
  }

  late final Local _local;
  late final Remote _remote;
  late final ConnectionManager _connectionManager;

  void initialize() {
    _subscribeLocalSupports();
    _subscribeLocalEntities();
    _subscribeRemoteFinances();
    getSupports();
  }

  //////////////////////////////////////////////////////////////////////////////
  final StreamController<List<SupportModel>> _localSupportsStreamController =
      StreamController.broadcast();

  final StreamController<List<EntityModel>> _localEntitiesStreamController =
      StreamController.broadcast();

  final StreamController<EntityModel> _remoteEntitiesStreamController =
      StreamController.broadcast();

  Stream<List<SupportModel>> get localSupportsStream =>
      _localSupportsStreamController.stream;

  Stream<List<EntityModel>> get localEntitiesStream =>
      _localEntitiesStreamController.stream;

  Stream<EntityModel> get remoteEntitiesStream =>
      _remoteEntitiesStreamController.stream;

  //////////////////////////////////////////////////////////////////////////////

  bool get connected => _connectionManager.connected;

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<bool>> getSupports() async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getSupports',
    );
    developer.log(
      'Attempting to fetch remote supports',
      name: 'Repo:getSupports',
    );
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch remote supports: remote connection is offline',
        name: 'Repo:getSupports',
      );
      return const Response(status: false, error: 'Connection is offline');
    }
    final remoteResponse = await _remote.getSupports();
    if (!remoteResponse.status) {
      developer.log(
        'Failed to fetch remote supports',
        name: 'Repo:getSupports',
      );
      return Response(status: false, error: remoteResponse.error!);
    }
    final list = remoteResponse.value!;
    final persistableSupports = list.map((e) => e.toRow()).toList();
    _local.setSupports(persistableSupports);
    return const Response(status: true, value: true);
  }

  //////////////////////////////////////////////////////////////////////////////
  // by field - stream based
  Future<Response<bool>> getEntitiesByField(final Field field) async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getEntitiesByField',
    );
    developer.log(
      'Attempting to fetch remote entities',
      name: 'Repo:getEntitiesByField',
    );
    String? error;
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch remote entities: remote connection is offline',
        name: 'Repo:getEntitiesByField',
      );
    } else {
      final remoteResponse = await _remote.getEntitiesByField(field);
      if (!remoteResponse.status) {
        developer.log(
          'Failed tot fetch remote entities: processing failure',
          name: 'Repo:getEntitiesByField',
        );
        error = remoteResponse.error!;
      } else {
        final list = remoteResponse.value!;
        final persistableEntities = list.map((e) => e.toRow()).toList();
        await _local.setEntities(persistableEntities, field);
      }
    }
    _local.getEntities(field);
    return Response(status: true, value: true, error: error);
  }

  //////////////////////////////////////////////////////////////////////////////
  // by field - request based
  Future<Response<List<EntityModel>>> getEntitiesByField(
    final Field field,
  ) async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getEntitiesByField',
    );
    developer.log(
      'Attempting to fetch remote entities',
      name: 'Repo:getEntitiesByField',
    );
    String? error;
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch remote entities: remote connection is offline',
        name: 'Repo:getEntitiesByField',
      );
    } else {
      final remoteResponse = await _remote.getEntitiesByField(field);
      if (!remoteResponse.status) {
        developer.log(
          'Failed tot fetch remote entities: processing failure',
          name: 'Repo:getEntitiesByField',
        );
        error = remoteResponse.error!;
      } else {
        final list = remoteResponse.value!;
        final persistableEntities = list.map((e) => e.toRow()).toList();
        await _local.setEntities(persistableEntities, field);
      }
    }
    final repoResponse = _local.getEntitiesByField(field);
    if (!repoResponse.status) {
      developer.log(
        'Failed to fetch local entities',
        name: 'Repo:getEntitiesByField',
      );
    }
    final list =
        repoResponse.value!.map((e) => EntityModel.fromRow(e)).toList();
    return Response(status: true, value: list, error: error);
  }

  //////////////////////////////////////////////////////////////////////////////
  // full-scan - by stream
  Future<Response<bool>> getEntities() async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getEntities',
    );
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch entities: connection is offline',
        name: 'Repo:getEntities',
      );
      return const Response(status: false, error: 'Connection is offline');
    }
    final remoteResponse = await _remote.getEntities();
    if (!remoteResponse.status) {
      developer.log(
        'Failed to fetch entities: processing error',
        name: 'Repo:getEntities',
      );
      return Response(status: false, error: remoteResponse.error);
    }
    final list = remoteResponse.value!;
    developer.log(
      'Fetched entities from remote: $list',
      name: 'Repo:getEntities',
    );
    final status = await _local.setEntities(list);
    if (!status) {
      developer.log(
        'Failed to save entities locally: processing failure',
        name: 'Repo:getEntities',
      );
      return const Response(
        status: false,
        value: false,
        error: 'Failed to save entities locally',
      );
    }
    return const Response(status: true, value: true);
  }

  //////////////////////////////////////////////////////////////////////////////
  // full-scan - by request
  Future<Response<List<EntityModel>>> getEntities() async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getEntities',
    );
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch entities: connection is offline',
        name: 'Repo:getEntities',
      );
      return const Response(status: false, error: 'Connection is offline');
    }
    final remoteResponse = await _remote.getEntities();
    if (!remoteResponse.status) {
      developer.log(
        'Failed to fetch entities: processing error',
        name: 'Repo:getEntities',
      );
      return Response(status: false, error: remoteResponse.error);
    }
    final list = remoteResponse.value!;
    developer.log(
      'Fetched entities from remote: $list',
      name: 'Repo:getEntities',
    );
    return Response(status: true, value: list);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<bool>> addEntity(final EntityModel entity) async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:addEntity',
    );
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to add finance: connection is offline',
        name: 'Repo:addEntity',
      );
      return const Response(status: false, error: 'Connection is offline');
    }
    final remoteResponse = await _remote.addEntity(entity);
    if (!remoteResponse.status) {
      developer.log(
        'Failed to add entity remotely',
        name: 'Repo:addEntity',
      );
      return Response(status: false, error: remoteResponse.error);
    }

    final id = remoteResponse.value!;
    final persistableEntity = entity.toRow().copyWith(id: Value(id));
    final status = await _local.addEntity(persistableEntity);
    if (status == false) {
      return const Response(
        status: false,
        error: 'Failed to add entity locally',
      );
    }
    return const Response(status: true, value: true);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<bool>> deleteEntity(
    final Field field,
  ) async {
    if (!_connectionManager.connected) {
      developer.log(
        'Cannot delete entity: connection is offline',
        name: 'Repo:deleteEntity',
      );
      return const Response(status: false, error: 'Connection is offline');
    }

    final remoteResponse = await _remote.deleteEntity(field);
    if (!remoteResponse.status) {
      developer.log(
        'Failed to delete entity remotely, due to error',
        name: 'Repo:deleteEntity',
      );
      return Response(status: false, error: remoteResponse.error);
    }

    if (!remoteResponse.value!) {
      developer.log(
        'Failed to delete entity remotely, request rejected',
        name: 'Repo:deleteEntity',
      );
      return Response(status: false, error: remoteResponse.error);
    }

    late final bool locallyDeleted;
    try {
      locallyDeleted = await _local.deleteEntity(field);
    } on Exception catch (e) {
      developer.log(
        'Failed to delete entity locally, due to error',
        name: 'Repo:deleteEntity',
      );
      return Response(status: false, error: e.toString());
    }

    if (!locallyDeleted) {
      developer.log(
        'Failed to delete entity locally, due to processing failure',
        name: 'Repo:deleteEntity',
      );
      return const Response(
        status: false,
        error: 'Failed to delete finance locally',
      );
    }
    return const Response(status: true, value: true);
  }

  //////////////////////////////////////////////////////////////////////////////
  void switchConnection() async {
    if (_connectionManager.connected) {
      _connectionManager.disconnect();
    }
    final status = await _connectionManager.connect();
    if (!status) {
      developer.log('Could not connect ws', name: 'Repo:switchConnection');
    }
    developer.log('Connected ws', name: 'Repo:switchConnection');
    getSupports();
  }

  void _subscribeLocalSupports() {
    _local.supportsStream.listen(
      (final List<Support> list) {
        final supports = list.map((e) => SupportModel.fromRow(e)).toList();
        _localSupportsStreamController.sink.add(supports);
      },
    );
  }

  void _subscribeLocalEntities() {
    _local.entitiesStream.listen(
      (final List<Entity> list) {
        final entities = list.map((e) => EntityModel.fromRow(e)).toList();
        _localEntitiesStreamController.sink.add(entities);
        developer.log(
          'Further dispatching entities: $entities',
          name: 'Repo:_subscribeLocalEntities',
        );
      },
    );
  }

  void _subscribeRemoteFinances() {
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to connect websocket to remote server',
        name: 'Repo:_subscribeRemoteFinances',
      );
      return;
    }
    _connectionManager.stream?.listen(
      (final event) {
        developer.log(
          'Received event from remote server through websocket incoming stream: $event',
          name: 'Repo:_subscribeRemote',
        );
        final jsonMap = jsonDecode(event);
        final entity = EntityModel.fromJson(jsonMap);
        _remoteEntitiesStreamController.sink.add(entity);
        developer.log(
          'Sent through outgoing stream: $entity',
          name: 'Repo:_subscribeRemote',
        );
      },
    );
  }
}
