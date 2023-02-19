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

  Stream<List<FinanceModel>> get financesStream => _repo.localFinancesStream;

  Future<Response<bool>> deleteFinance(final int id, final String date) async =>
      await _repo.deleteFinance(id, date);
}
