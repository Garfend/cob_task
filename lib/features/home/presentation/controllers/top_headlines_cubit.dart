import '../../../../core/base/base_cubit.dart';
import '../../data/models/article_model.dart';
import '../../data/params/top_headlines_params.dart';
import '../../data/repos/home_repository.dart';

class TopHeadlinesCubit extends BaseCubit<List<ArticleModel>> {
  final HomeRepository _repository;

  TopHeadlinesCubit(this._repository);

  Future<void> fetchTopHeadlines({String? country, String? category}) async {
    emitLoading();

    final params = TopHeadlinesParams.defaultHome(country: country ?? 'us');

    final result = await _repository.getTopHeadlines(params);

    if (result.failure != null) {
      emitError(result.failure!);
    } else if (result.data != null) {
      final articles = result.data!.validArticles;
      if (articles.isEmpty) {
        emitEmpty('No top headlines available');
      } else {
        emitSuccess(articles);
      }
    }
  }

  Future<void> refresh({String? country}) =>
      fetchTopHeadlines(country: country);
}
