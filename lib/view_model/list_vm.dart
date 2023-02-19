import '../model/model.dart';
import '../repo/repo.dart';

class ListViewModel {
  ListViewModel({
    required repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  Stream<List<DateModel>> get datesStream => _repo.localDatesStream;

  void getFinances(final String date) => _repo.getFinances(date);
}
