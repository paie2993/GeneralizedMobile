import '../model/model.dart';
import '../repo/repo.dart';

class ConnectionViewModel {
  ConnectionViewModel({
    required Repo repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  bool get connected => _repo.connected;

  Stream<FinanceModel> get stream => _repo.remoteEntitiesStream;

  void switchConnection() => _repo.switchConnection();
}
