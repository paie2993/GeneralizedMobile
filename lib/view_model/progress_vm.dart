import '../logic/progress_logic.dart';
import '../model/progress_model.dart';
import '../model/response/response.dart';
import '../repo/repo.dart';

class ProgressViewModel {
  ProgressViewModel({
    required Repo repo,
  }) {
    _repo = repo;
  }

  late final Repo _repo;

  Future<Response<List<TimeSpan>>> getWeeks() async {
    final repoResponse = await _repo.getFinanceEntries();
    if (!repoResponse.status) {
      return Response(status: false, error: repoResponse.error);
    }
    final list = buildWeeks(repoResponse.value!);
    return Response(status: true, value: list);
  }
}
