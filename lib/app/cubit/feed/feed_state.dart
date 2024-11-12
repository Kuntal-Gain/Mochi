part of 'feed_cubit.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoadedTrending extends FeedState {
  final List<FeedEntity> mangaList;

  const FeedLoadedTrending({required this.mangaList});

  @override
  List<Object> get props => [mangaList];
}

class FeedLoadedLatest extends FeedState {
  final List<FeedEntity> mangaList;

  const FeedLoadedLatest({required this.mangaList});

  @override
  List<Object> get props => [mangaList];
}

class FeedLoadedAll extends FeedState {
  final List<FeedEntity> mangaList;

  const FeedLoadedAll({required this.mangaList});

  @override
  List<Object> get props => [mangaList];
}

class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  List<Object> get props => [message];
}
