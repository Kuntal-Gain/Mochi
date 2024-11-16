// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/domain/entities/feed_entity.dart';

import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import '../../utils/constants/text_constants.dart';
import '../cubit/manga/manga_cubit.dart';
import '../screens/manga_details_screen.dart';

Widget trendingCardWidget(List<FeedEntity> mangaList) {
  return Container(
    height: 300,
    padding: const EdgeInsets.all(Sizes.md),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mangaList.length < 9 ? mangaList.length : 9,
      itemBuilder: (context, index) {
        final mangaData = mangaList[index];
        return GestureDetector(
          onTap: () {
            context
                .read<MangaCubit>()
                .getMangaDataUsecase(mangaData.id)
                .then((manga) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaDetailsScreen(
                    manga: manga,
                    mangaId: mangaData.id,
                  ),
                ),
              );
            });
          },
          child: Container(
            width: 200,
            margin: const EdgeInsets.only(right: Sizes.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 40,
                  color: AppColors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${index + 1} ',
                          style: TextConst.headingStyle(24, AppColors.white),
                        ),
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              width: 180,
                              alignment: Alignment.center,
                              child: Text(
                                mangaList[index].title.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style:
                                    TextConst.headingStyle(12, AppColors.white),
                              ),
                            ),
                          ),
                        ),
                        sizeVer(Sizes.sm),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                        child: Image.network(
                          mangaList[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
