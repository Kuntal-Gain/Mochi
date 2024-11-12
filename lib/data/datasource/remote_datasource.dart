import '../../domain/entities/chapter_entity.dart';
import '../../domain/entities/feed_entity.dart';
import '../../domain/entities/manga_entity.dart';
import '../../domain/entities/user_entity.dart';

abstract class RemoteDataSource {
  Future<List<FeedEntity>> getTrendingMangaList();
  Future<List<FeedEntity>> getLatestMangaList();
  Future<List<FeedEntity>> getMangaListByCategory(String category);
  Future<List<FeedEntity>> getAllMangaList();

  // data
  Future<MangaEntity> getMangaData(String id);
  Future<List<String>> getChapters(String id);

  // chapter
  Future<ChapterEntity> getChapterPages(String chapterId, String mangaId);

  // user
  Future<void> registerUser(UserEntity user);
  Future<void> loginUser(String email, String password);
  Future<void> logoutUser();
}
