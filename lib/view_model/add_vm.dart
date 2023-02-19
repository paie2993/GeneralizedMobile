import '../model/model.dart';
import '../repo/repo.dart';

class AddViewModel {
  AddViewModel({
    required repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  void add(final FinanceModel finance) => _repo.addFinance(finance);
}
