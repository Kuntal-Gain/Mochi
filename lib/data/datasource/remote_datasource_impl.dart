import 'dart:convert';

import 'package:mochi/domain/entities/chapter_entity.dart';
import 'package:mochi/domain/entities/user_entity.dart';

import '../../domain/entities/manga_entity.dart';
import '../datasource/remote_datasource.dart';
import '../models/chapter_model.dart';
import '../models/feed_model.dart';
import 'package:http/http.dart' as http;

import '../models/manga_model.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<List<FeedModel>> getTrendingMangaList() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mangaapi-production-39b0.up.railway.app/api/mangaList?type=topview'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['mangaList'];
        return jsonData.map((manga) => FeedModel.fromJson(manga)).toList();
      } else {
        throw Exception('Failed to load trending manga');
      }
    } catch (e) {
      throw Exception('Error getting trending manga: $e');
    }
  }

  @override
  Future<List<FeedModel>> getAllMangaList() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mangaapi-production-39b0.up.railway.app/api/mangaList'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['mangaList'];
        return jsonData.map((manga) => FeedModel.fromJson(manga)).toList();
      } else {
        throw Exception('Failed to load all manga');
      }
    } catch (e) {
      throw Exception('Error getting all manga: $e');
    }
  }

  @override
  Future<List<FeedModel>> getLatestMangaList() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mangaapi-production-39b0.up.railway.app/api/mangaList?type=latest'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['mangaList'];
        return jsonData.map((manga) => FeedModel.fromJson(manga)).toList();
      } else {
        throw Exception('Failed to load latest manga');
      }
    } catch (e) {
      throw Exception('Error getting latest manga: $e');
    }
  }

  @override
  Future<List<FeedModel>> getMangaListByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mangaapi-production-39b0.up.railway.app/api/mangaList?category=$category'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['mangaList'];
        return jsonData.map((manga) => FeedModel.fromJson(manga)).toList();
      } else {
        throw Exception('Failed to load manga by category');
      }
    } catch (e) {
      throw Exception('Error getting manga by category: $e');
    }
  }

  @override
  Future<MangaEntity> getMangaData(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mangaapi-production-39b0.up.railway.app/api/manga/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return MangaModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load manga data');
      }
    } catch (e) {
      throw Exception('Error getting manga data: $e');
    }
  }

  @override
  Future<List<String>> getChapters(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mangaapi-production-39b0.up.railway.app/api/manga/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> chapterList = jsonData['chapterList'] ?? [];
        return chapterList
            .map((chapter) => (chapter as Map<String, dynamic>)['id'] as String)
            .toList();
      } else {
        throw Exception('Failed to load chapters');
      }
    } catch (e) {
      throw Exception('Error getting chapters: $e');
    }
  }

  @override
  Future<ChapterEntity> getChapterPages(
      String chapterId, String mangaId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://mangaapi-production-39b0.up.railway.app/api/manga/$mangaId/$chapterId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ChapterModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load chapter pages');
      }
    } catch (e) {
      throw Exception('Error getting chapter pages: $e');
    }
  }

  @override
  Future<void> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://mochi-backend-production.up.railway.app/v1/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to login user');
      }
    } catch (e) {
      throw Exception('Error logging in user: $e');
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      final response = await http.post(
        Uri.parse('https://mochi-backend-production.up.railway.app/v1/user/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to logout user');
      }
    } catch (e) {
      throw Exception('Error logging out user: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final response = await http.post(
        Uri.parse('https://mochi-backend-production.up.railway.app/v1/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': user.username,
          'email': user.email,
          'history': user.history,
          'readingList': user.readingList,
          'favouriteManga': user.favouriteManga,
          'timeSpent': user.timeSpent,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }
}
