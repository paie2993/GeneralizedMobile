import '../model/model.dart';
import '../model/response/response.dart';
import '../repo/repo.dart';

class DetailsViewModel {
  DetailsViewModel({
    required repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  // stream based
  Stream<List<EntityModel>> get entitiesStream => _repo.localEntitiesStream;

  // request based - by field
  Future<Response<List<EntityModel>>> getEntitiesByField(final Field field) =>
      _repo.getEntitiesByField(field);

  // request based - full-scan
  Future<Response<List<EntityModel>>> getEntities() => _repo.getEntities();

  // delete entity
  Future<Response<bool>> deleteEntity(final Field field) async =>
      await _repo.deleteEntity(field);
}
