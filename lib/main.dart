import 'package:base/remote/connection_manager.dart';
import 'package:base/remote/remote.dart';
import 'package:base/repo/repo.dart';
import 'package:base/view/list.dart';
import 'package:base/view_model/add_vm.dart';
import 'package:base/view_model/connection_vm.dart';
import 'package:base/view_model/details_vm.dart';
import 'package:base/view_model/list_vm.dart';
import 'package:base/view_model/progress_vm.dart';
import 'package:base/view_model/top_vm.dart';
import 'package:flutter/material.dart';

import 'local/localdb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final local = Local();
  final remote = Remote();
  final connectionManager = ConnectionManager();
  await connectionManager.connect();

  final repo = Repo(
    local: local,
    remote: remote,
    connectionManager: connectionManager,
  );
  repo.initialize();

  final listViewModel = ListViewModel(repo: repo);
  final progressViewModel = ProgressViewModel(repo: repo);
  final topViewModel = TopViewModel(repo: repo);
  final detailsViewModel = DetailsViewModel(repo: repo);
  final addViewModel = AddViewModel(repo: repo);
  final connectionViewModel = ConnectionViewModel(repo: repo);

  runApp(
    MaterialApp(
      title: 'BaseApp',
      home: ListWidget(
        listViewModel: listViewModel,
        progressViewModel: progressViewModel,
        topViewModel: topViewModel,
        detailsViewModel: detailsViewModel,
        addViewModel: addViewModel,
        connectionViewModel: connectionViewModel,
      ),
    ),
  );
}
