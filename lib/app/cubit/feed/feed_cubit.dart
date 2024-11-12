import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mochi/domain/usecases/feed/get_all_mangalist_usecase.dart';
import 'package:mochi/domain/usecases/feed/get_latest_arrival_usecase.dart';
import 'package:mochi/domain/usecases/feed/get_mangalist_by_category_usecase.dart';
import 'package:mochi/domain/usecases/feed/get_trending_manga_usecase.dart';

import '../../../domain/entities/feed_entity.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final GetAllMangaListUsecase getAllMangaListUsecase;
  final GetTrendingMangaListUsecase getTrendingMangaListUsecase;
  final GetLatestArrivalUsecase getLatestArrivalUsecase;
  final GetMangaListByCategoryUsecase getMangaListByCategoryUsecase;

  FeedCubit({
    required this.getAllMangaListUsecase,
    required this.getTrendingMangaListUsecase,
    required this.getLatestArrivalUsecase,
    required this.getMangaListByCategoryUsecase,
  }) : super(FeedInitial());

  Future<void> fetchAll() async {
    try {
      emit(FeedLoading());
      final result = await getAllMangaListUsecase();
      emit(FeedLoadedAll(mangaList: result));
    } catch (e) {
      emit(FeedError(message: e.toString()));
    }
  }

  Future<void> fetchTrending() async {
    try {
      emit(FeedLoading());
      final result = await getTrendingMangaListUsecase();
      emit(FeedLoadedTrending(mangaList: result));
    } catch (e) {
      emit(FeedError(message: e.toString()));
    }
  }

  Future<void> fetchLatest() async {
    try {
      emit(FeedLoading());
      final result = await getLatestArrivalUsecase();
      emit(FeedLoadedLatest(mangaList: result));
    } catch (e) {
      emit(FeedError(message: e.toString()));
    }
  }

  Future<void> fetchByCategory(String category) async {
    try {
      emit(FeedLoading());
      final result = await getMangaListByCategoryUsecase(category);
      emit(FeedLoadedAll(mangaList: result));
    } catch (e) {
      emit(FeedError(message: e.toString()));
    }
  }
}
