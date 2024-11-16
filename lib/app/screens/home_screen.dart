import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/app/cubit/feed/feed_cubit.dart';
import 'package:mochi/app/cubit/user/user_cubit.dart';
import 'package:mochi/app/screens/user_profile.dart';
import 'package:mochi/app/widgets/latest_arrival_widget.dart';
import 'package:mochi/app/widgets/slider_card_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/feed_entity.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import '../../utils/constants/text_constants.dart';
import '../widgets/trending_card_widget.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.uid});

  final String uid;

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

    // Fetch user data using UserCubit
    context.read<UserCubit>().fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userState is UserLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/logo.jpg',
                          height: Sizes.imageMd,
                          width: Sizes.imageMd,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    UserProfile(user: userState.user)));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: const CircleAvatar(
                              radius: Sizes.lg,
                              backgroundColor: AppColors.primary,
                              foregroundImage: NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/512/2102/2102647.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search bar
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
                    margin: const EdgeInsets.symmetric(horizontal: Sizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffc2c2c2),
                          blurRadius: 1,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search for Mangas',
                          border: InputBorder.none,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchScreen()));
                        },
                      ),
                    ),
                  ),

                  // Carousel
                  sizeVer(10),
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
                        // Ensure parent has a defined size
                        return BlocConsumer<FeedCubit, FeedState>(
                          listener: (context, state) {
                            if (state is FeedLoadedTrending) {
                              setState(() {
                                trendingMangaList = state.mangaList;
                              });
                            }
                          },
                          builder: (context, state) {
                            if (trendingMangaList.isEmpty) {
                              // Ensure parent has a defined size
                              return SizedBox(
                                height:
                                    200, // Set height for the horizontal ListView
                                width: double
                                    .infinity, // Set width based on screen size
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.md),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (ctx, idx) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        // Fill available width
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.75, // Divide width equally for each item
                                        // Margin between items
                                        margin: const EdgeInsets.only(
                                            right: Sizes.md),
                                        decoration: BoxDecoration(
                                          color: Colors.grey
                                              .shade200, // Ensure it's visible
                                          borderRadius: BorderRadius.circular(
                                              Sizes.borderRadiusLg),
                                          border: Border.all(
                                              color: Colors.red,
                                              width:
                                                  1), // Temporary border for visibility
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }

                            // When data is loaded, show actual widget
                            return sliderCardWidget(trendingMangaList);
                          },
                        );
                      }
                      // When data is loaded, show actual widget
                      return sliderCardWidget(trendingMangaList);
                    },
                  ),

                  // Continue reading section

                  if (userState.user.readingList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
                      child: Text(
                        "Continue Reading",
                        style: TextConst.headingStyle(Sizes.fontXl, null),
                      ),
                    ),

                  if (userState.user.readingList.isNotEmpty)
                    SizedBox(
                      height: mq.size.height * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: Sizes.md),
                        itemCount: userState.user.readingList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: Sizes.md),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Sizes.borderRadiusLg),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 180,
                                  child: Image.asset(
                                    'assets/manga/${index + 1}.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(Sizes.sm),
                                  child: Text(
                                    "Manga ${index + 1}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextConst.headingStyle(
                                        16, AppColors.black),
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
                                      style: TextConst.headingStyle(
                                          16, AppColors.white),
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

                  // New arrival
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
                        // Show shimmer effect while loading
                        return SizedBox(
                          height: 300, // or any height that suits your design
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                margin: const EdgeInsets.all(Sizes.md),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(
                                      Sizes.borderRadiusLg),
                                ),
                              )),
                        );
                      }
                      // Show the actual widget when data is loaded
                      return latestArrivalWidget(newArrivalMangaList);
                    },
                  ),

                  // Weekly ranking
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
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator()); // Default fallback
          }
        },
      ),
    );
  }
}
