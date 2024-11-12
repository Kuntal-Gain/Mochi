import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/app/screens/manga_details_screen.dart';
import 'package:mochi/utils/constants/text_constants.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/manga_model.dart';
import '../../domain/entities/manga_entity.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import '../cubit/feed/feed_cubit.dart';
import 'package:http/http.dart' as http;

import '../cubit/manga/manga_cubit.dart';
import '../widgets/search_tile_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FeedCubit>().fetchAll();
  }

  List<String> results = [];
  TextEditingController _searchController = TextEditingController();

  // Add this import if not already present
  Map<String, MangaEntity> mangaData = {};

  // Add loading state variables
  bool isSearching = false;

  Future<void> searchManga(String query) async {
    // Show loading indicator
    setState(() {
      isSearching = true;
      results = [];
      mangaData.clear();
    });

    final response = await http.get(
      Uri.parse(
          'https://mangaapi-production-39b0.up.railway.app/api/search/${query}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> mangaList = data['mangaList'];
      final List<String> titles =
          mangaList.map((manga) => manga['id'].toString()).toList();

      // Update results but keep isSearching true while fetching details
      setState(() {
        results = titles;
      });

      // Fetch manga details for each ID
      for (String id in titles) {
        final mangaResponse = await http.get(
          Uri.parse(
              'https://mangaapi-production-39b0.up.railway.app/api/manga/$id'),
        );

        if (mangaResponse.statusCode == 200) {
          final mangaJson = json.decode(mangaResponse.body);
          // Convert JSON to MangaEntity
          final mangaEntity = MangaModel.fromJson(mangaJson);
          setState(() {
            mangaData[id] = mangaEntity;
          });
        }
      }

      // Set isSearching to false after all details are fetched
      setState(() {
        isSearching = false;
      });
    } else {
      setState(() {
        isSearching = false;
      });
      throw Exception('Failed to search manga');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            child: Container(
              child: Image.asset(
                'assets/logo.jpg',
                height: Sizes.imageMd,
                width: Sizes.imageMd,
              ),
            ),
          ),

          // searchbar
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: Sizes.md),
            margin: EdgeInsets.symmetric(horizontal: Sizes.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffc2c2c2),
                  blurRadius: 1,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for Mangas',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    searchManga(_searchController.text);
                  },
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/711/711319.png',
                    height: 35,
                    width: 35,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Sizes.md),
          BlocBuilder<FeedCubit, FeedState>(
            builder: (context, state) {
              if (state is FeedLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is FeedLoadedAll) {
                final feed = state.mangaList;

                print(results);

                if (_searchController.text.isEmpty) {
                  return Center(
                    child: Text('Search for Manga'),
                  );
                }

                if (isSearching && results.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final id = results[index];
                      final manga = mangaData[id];

                      if (manga == null) {
                        return Container(
                          margin: EdgeInsets.all(Sizes.md),
                          height: 230,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: Sizes.md,
                                      top: Sizes.md,
                                      bottom: Sizes.md,
                                    ),
                                    child: Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          color: Colors.grey[200],
                                          margin: EdgeInsets.only(bottom: 8),
                                        ),
                                        Container(
                                          height: 20,
                                          width: 150,
                                          color: Colors.grey[200],
                                          margin: EdgeInsets.only(bottom: 16),
                                        ),
                                        Container(
                                          height: 20,
                                          color: Colors.grey[200],
                                          margin: EdgeInsets.only(bottom: 8),
                                        ),
                                        Container(
                                          height: 20,
                                          color: Colors.grey[200],
                                          margin: EdgeInsets.only(bottom: 8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MangaDetailsScreen(
                                manga: manga,
                                mangaId: id,
                              ),
                            ),
                          );
                        },
                        child: searchTileWidget(manga, context),
                      );
                    },
                  ),
                );
              }

              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
