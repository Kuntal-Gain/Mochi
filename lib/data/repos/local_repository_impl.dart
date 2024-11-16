import 'package:mochi/domain/entities/user_entity.dart';

import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/feed_entity.dart';
import '../../domain/entities/manga_entity.dart';
import '../../domain/repos/local_repository.dart';
import '../datasource/remote_datasource.dart';

class LocalRepositoryImpl implements LocalRepository {
  final RemoteDataSource dataSource;

  LocalRepositoryImpl({required this.dataSource});

  @override
  Future<List<FeedEntity>> getTrendingMangaList() async =>
      dataSource.getTrendingMangaList();

  @override
  Future<List<FeedEntity>> getAllMangaList() async =>
      dataSource.getAllMangaList();

  @override
  Future<List<FeedEntity>> getLatestMangaList() async =>
      dataSource.getLatestMangaList();

  @override
  Future<List<FeedEntity>> getMangaListByCategory(String category) async =>
      dataSource.getMangaListByCategory(category);

  @override
  Future<MangaEntity> getMangaData(String id) async =>
      dataSource.getMangaData(id);

  @override
  Future<List<String>> getChapters(String id) async =>
      dataSource.getChapters(id);

  @override
  Future<ChapterEntity> getChapterPages(
          String chapterId, String mangaId) async =>
      dataSource.getChapterPages(chapterId, mangaId);

  @override
  Future<void> registerUser(UserEntity user) async =>
      dataSource.registerUser(user);

  @override
  Future<void> loginUser(String email, String password) async =>
      dataSource.loginUser(email, password);

  @override
  Future<void> logoutUser() async => dataSource.logoutUser();

  @override
  Future<UserEntity> getUser() async => dataSource.getUser();

  @override
  Future<bool> isSignIn() async => dataSource.isSignIn();
}
