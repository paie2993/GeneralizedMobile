import '../model/model.dart';
import '../repo/repo.dart';

class ListViewModel {
  ListViewModel({
    required repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  Stream<List<SupportModel>> get supportsStream => _repo.localSupportsStream;

  void getEntities(final Field field) => _repo.getEntitiesByField(field);
}
