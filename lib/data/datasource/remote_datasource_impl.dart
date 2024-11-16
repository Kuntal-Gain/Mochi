import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mochi/domain/entities/chapter_entity.dart';
import 'package:mochi/domain/entities/user_entity.dart';

import '../../domain/entities/manga_entity.dart';
import '../datasource/remote_datasource.dart';
import '../models/chapter_model.dart';
import '../models/feed_model.dart';
import 'package:http/http.dart' as http;

import '../models/manga_model.dart';
import '../models/user_model.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  RemoteDataSourceImpl(
      {required FirebaseAuth auth, required FirebaseFirestore firestore})
      : _auth = auth,
        _firestore = firestore;

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
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print(e.code);
      } else if (e.code == 'wrong-password') {
        print(e.code);
      }
    }
  }

  @override
  Future<void> logoutUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _auth.signOut();
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      if (user.email.isNotEmpty || user.password.isNotEmpty) {
        await _auth
            .createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        )
            .then((value) async {
          if (value.user?.uid != null) {
            final userCollection = _firestore.collection('users');

            final uid = FirebaseAuth.instance.currentUser?.uid;

            userCollection.doc(uid).get().then((newDoc) {
              final newUser = UserModel(
                username: user.username,
                email: user.email,
                history: user.history,
                readingList: user.readingList,
                favouriteManga: user.favouriteManga,
                timeSpent: user.timeSpent,
                password: user.password,
                uid: uid!,
              ).toJson();

              if (!newDoc.exists) {
                userCollection.doc(uid).set(newUser);
              } else {
                userCollection.doc(uid).update(newUser);
              }
            }).catchError((err) {
              print(err.toString());
            });
          }
          print("Account Creation Successful");
        });

        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print(e.code);
      } else {
        print('Something went wrong');
      }
    }
  }

  @override
  Future<UserEntity> getUser() async {
    try {
      // Get the currently logged-in user's UID
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in.");
      }

      // Fetch the user document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        throw Exception("User not found in Firestore.");
      }

      // Parse the document data into a UserEntity object
      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  @override
  Future<bool> isSignIn() async => _auth.currentUser?.uid != null;
}
