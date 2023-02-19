import '../model/model.dart';
import '../repo/repo.dart';

class AddViewModel {
  AddViewModel({
    required repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  void add(final EntityModel entity) => _repo.addEntity(entity);
}
