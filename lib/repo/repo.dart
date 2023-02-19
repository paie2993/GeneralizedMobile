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
    _subscribeLocalDates();
    _subscribeLocalFinances();
    _subscribeRemoteFinances();
    getDates();
  }

  //////////////////////////////////////////////////////////////////////////////
  final StreamController<List<DateModel>> _localDatesStreamController =
      StreamController.broadcast();

  final StreamController<List<FinanceModel>> _localFinancesStreamController =
      StreamController.broadcast();

  final StreamController<FinanceModel> _remoteFinancesStreamController =
      StreamController.broadcast();

  Stream<List<DateModel>> get localDatesStream =>
      _localDatesStreamController.stream;

  Stream<List<FinanceModel>> get localFinancesStream =>
      _localFinancesStreamController.stream;

  Stream<FinanceModel> get remoteFinancesStream =>
      _remoteFinancesStreamController.stream;

  //////////////////////////////////////////////////////////////////////////////

  bool get connected => _connectionManager.connected;

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<bool>> getDates() async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getDates',
    );
    developer.log(
      'Attempting to fetch remote dates',
      name: 'Repo:getDates',
    );
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch remote dates: remote connection is offline',
        name: 'Repo:getDates',
      );
      return const Response(status: false, error: 'Connection is offline');
    }
    final remoteResponse = await _remote.getDates();
    if (!remoteResponse.status) {
      developer.log(
        'Failed tot fetch remote dates',
        name: 'Repo:getDates',
      );
      return Response(status: false, error: remoteResponse.error!);
    }
    final list = remoteResponse.value!;
    final persistableDates = list.map((e) => e.toRow()).toList();
    _local.setDates(persistableDates);
    return const Response(status: true, value: true);
  }

  Future<Response<bool>> getFinances(final String date) async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getFinances',
    );
    developer.log(
      'Attempting to fetch remote finances',
      name: 'Repo:getFinances',
    );
    String? error;
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch remote finances: remote connection is offline',
        name: 'Repo:getFinances',
      );
    } else {
      final remoteResponse = await _remote.getFinances(date);
      if (!remoteResponse.status) {
        developer.log(
          'Failed tot fetch remote finances: processing failure',
          name: 'Repo:getFinances',
        );
        error = remoteResponse.error!;
      } else {
        final list = remoteResponse.value!;
        final persistableFinances = list.map((e) => e.toRow()).toList();
        await _local.setFinances(persistableFinances, date);
      }
    }
    _local.getFinances(date);
    return Response(status: true, value: true, error: error);
  }

  Future<Response<List<FinanceModel>>> getFinanceEntries() async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:getFinanceEntries',
    );
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to fetch finance entries: connection is offline',
        name: 'Repo:getFinanceEntries',
      );
      return const Response(status: false, error: 'Connection is offline');
    }
    final remoteResponse = await _remote.getFinanceEntries();
    if (!remoteResponse.status) {
      developer.log(
        'Failed to fetch finance entries: processing error',
        name: 'Repo:getFinanceEntries',
      );
      return Response(status: false, error: remoteResponse.error);
    }
    final list = remoteResponse.value!;
    developer.log(
      'Fetched finance entries from remote: $list',
      name: 'Repo:getFinanceEntries',
    );
    return Response(status: true, value: list);
  }

  //////////////////////////////////////////////////////////////////////////////
  Future<Response<bool>> addFinance(final FinanceModel finance) async {
    developer.log(
      'Repo call *****************************',
      name: 'Repo:addFinance',
    );
    if (!_connectionManager.connected) {
      developer.log(
        'Failed to add finance: connection is offline',
        name: 'Repo:addFinance',
      );
      return const Response(status: false, error: 'Connection is offline');
    }
    final remoteResponse = await _remote.addFinance(finance);
    if (!remoteResponse.status) {
      developer.log(
        'Failed to add finance remotely',
        name: 'Repo:addFinance',
      );
      return Response(status: false, error: remoteResponse.error);
    }

    final id = remoteResponse.value!;
    final persistableFinance = finance.toRow().copyWith(id: Value(id));
    final status = await _local.addFinance(persistableFinance);
    if (status == false) {
      return const Response(
        status: false,
        error: 'Failed to add finance locally',
      );
    }
    return const Response(status: true, value: true);
  }

  Future<Response<bool>> deleteFinance(
    final int id,
    final String date,
  ) async {
    if (!_connectionManager.connected) {
      developer.log(
        'Cannot delete finance: connection is offline',
        name: 'Repo:deleteFinance',
      );
      return const Response(status: false, error: 'Connection is offline');
    }

    final remoteResponse = await _remote.deleteFinance(id);
    if (!remoteResponse.status) {
      developer.log(
        'Failed to delete finance remotely, due to error',
        name: 'Repo:deleteFinance',
      );
      return Response(status: false, error: remoteResponse.error);
    }

    if (!remoteResponse.value!) {
      developer.log(
        'Failed to delete finance remotely, request rejected',
        name: 'Repo:deleteFinance',
      );
      return Response(status: false, error: remoteResponse.error);
    }

    late final bool locallyDeleted;
    try {
      locallyDeleted = await _local.deleteFinance(id, date);
    } on Exception catch (e) {
      developer.log(
        'Failed to delete finance locally, due to error',
        name: 'Repo:deleteFinance',
      );
      return Response(status: false, error: e.toString());
    }

    if (!locallyDeleted) {
      developer.log(
        'Failed to delete finance locally, due to processing failure',
        name: 'Repo:deleteFinance',
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
    getDates();
  }

  void _subscribeLocalDates() {
    _local.datesStream.listen(
      (final List<Date> list) {
        final dates = list.map((e) => DateModel.fromRow(e)).toList();
        _localDatesStreamController.sink.add(dates);
      },
    );
  }

  void _subscribeLocalFinances() {
    _local.currentFinancesStream.listen(
      (final List<Finance> list) {
        final finances = list.map((e) => FinanceModel.fromRow(e)).toList();
        _localFinancesStreamController.sink.add(finances);
        developer.log(
          'Further dispatching finances: $finances',
          name: 'Repo:_subscribeLocalFinances',
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
        final finance = FinanceModel.fromJson(jsonMap);
        _remoteFinancesStreamController.sink.add(finance);
        developer.log(
          'Sent through outgoing stream: $finance',
          name: 'Repo:_subscribeRemote',
        );
      },
    );
  }
}
