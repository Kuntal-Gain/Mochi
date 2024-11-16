import 'package:mochi/domain/entities/manga_entity.dart';
import 'package:mochi/domain/entities/user_entity.dart';

import '../entities/chapter_entity.dart';
import '../entities/feed_entity.dart';

abstract class LocalRepository {
  // feed
  Future<List<FeedEntity>> getTrendingMangaList();
  Future<List<FeedEntity>> getLatestMangaList();
  Future<List<FeedEntity>> getAllMangaList();
  Future<List<FeedEntity>> getMangaListByCategory(String category);

  // data
  Future<MangaEntity> getMangaData(String id);
  Future<List<String>> getChapters(String id);

  // chapter
  Future<ChapterEntity> getChapterPages(String chapterId, String mangaId);

  // user
  Future<void> registerUser(UserEntity user);
  Future<void> loginUser(String email, String password);
  Future<void> logoutUser();
  Future<UserEntity> getUser();
  Future<bool> isSignIn();
}
