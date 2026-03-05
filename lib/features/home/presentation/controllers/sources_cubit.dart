import '../../../../core/base/base_cubit.dart';
import '../../data/models/source_model.dart';
import '../../data/repos/home_repository.dart';

class SourcesCubit extends BaseCubit<List<SourceModel>> {
  final HomeRepository _repository;

  SourcesCubit(this._repository);

  Future<void> fetchSources({
    String? category,
    String? language,
    String? country,
  }) async {
    emitLoading();

    final result = await _repository.getSources(
      category: category,
      language: language,
      country: country,
    );

    if (result.failure != null) {
      emitError(result.failure!);
    } else if (result.data != null) {
      final sources = result.data!.sources;
      if (sources.isEmpty) {
        emitEmpty('No sources available');
      } else {
        emitSuccess(sources);
      }
    }
  }

  Future<void> refresh({String? language}) => fetchSources(language: language);
}
