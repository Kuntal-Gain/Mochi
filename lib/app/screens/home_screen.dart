import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mochi/app/cubit/feed/feed_cubit.dart';
import 'package:mochi/app/widgets/latest_arrival_widget.dart';
import 'package:mochi/app/widgets/slider_card_widget.dart';

import '../../domain/entities/feed_entity.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import '../../utils/constants/text_constants.dart';
import 'package:mochi/dependency_injection.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/trending_card_widget.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FeedEntity> trendingMangaList = [];
  List<FeedEntity> newArrivalMangaList = [];

  @override
  void initState() {
    super.initState();
    context.read<FeedCubit>()
      ..fetchTrending()
      ..fetchLatest();
  }

  @override
  Widget build(BuildContext context) {
    List<String> mangaList = [
      'Dragon Ball Super',
      'Mashle',
      'Bleach',
      'One Piece',
    ];

    var mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/logo.jpg',
                      height: Sizes.imageMd,
                      width: Sizes.imageMd,
                    ),
                  ),
                  CircleAvatar(
                    radius: Sizes.xl,
                    backgroundColor: AppColors.primary,
                  ),
                ],
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
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for Mangas',
                    border: InputBorder.none,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                ),
              ),
            ),
            // carousel
            BlocConsumer<FeedCubit, FeedState>(
              listener: (context, state) {
                if (state is FeedLoadedTrending) {
                  setState(() {
                    trendingMangaList = state.mangaList;
                  });
                }
              },
              builder: (context, state) {
                if (trendingMangaList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return sliderCardWidget(trendingMangaList);
              },
            ),
            // continue reading
            sizeVer(Sizes.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
              child: Text(
                "Continue Reading",
                style: TextConst.headingStyle(Sizes.fontXl, null),
              ),
            ),
            sizeVer(Sizes.spaceBtwItems),
            SizedBox(
              height: mq.size.height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: Sizes.md),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 180,
                          child: Image.asset(
                            'assets/manga/${index + 1}.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(Sizes.sm),
                          child: Text(
                            mangaList[index],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextConst.headingStyle(16, AppColors.black),
                          ),
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'Read [CH${index + 1}]',
                              style:
                                  TextConst.headingStyle(16, AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            sizeVer(Sizes.md),
            // new arrival
            BlocConsumer<FeedCubit, FeedState>(
              listener: (context, state) {
                if (state is FeedLoadedLatest) {
                  setState(() {
                    newArrivalMangaList = state.mangaList;
                  });
                }
              },
              builder: (context, state) {
                if (newArrivalMangaList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return latestArrivalWidget(newArrivalMangaList);
              },
            ),
            // weekly ranking
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Trending',
                style: TextConst.headingStyle(24, AppColors.black),
              ),
            ),
            BlocBuilder<FeedCubit, FeedState>(
              builder: (context, state) {
                if (trendingMangaList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return trendingCardWidget(trendingMangaList);
              },
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Copyright @ Kuntal Gain',
                  style: TextConst.headingStyle(16, AppColors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
