import '../logic/top_logic.dart';
import '../model/response/response.dart';
import '../model/top_model.dart';
import '../repo/repo.dart';

class TopViewModel {
  TopViewModel({
    required Repo repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  Future<Response<List<TransactionCategory>>> getCategories() async {
    final repoResponse = await _repo.getFinanceEntries();
    if (!repoResponse.status) {
      return Response(status: false, error: repoResponse.error);
    }
    final list = buildCategories(repoResponse.value!);
    return Response(status: true, value: list);
  }
}
