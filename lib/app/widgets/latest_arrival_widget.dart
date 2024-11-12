import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/feed_entity.dart';
import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import '../../utils/constants/text_constants.dart';
import '../cubit/manga/manga_cubit.dart';
import '../screens/manga_details_screen.dart';

Widget latestArrivalWidget(List<FeedEntity> mangaList) {
  return Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: AppColors.primary,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'New Arrival',
            style: TextConst.headingStyle(24, AppColors.white),
          ),
        ),
        Container(
          height: 300,
          padding: EdgeInsets.all(Sizes.md),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mangaList.length,
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
                  width: 140,
                  margin: EdgeInsets.only(right: Sizes.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        child: Image.network(
                          mangaData.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.sm),
                          child: Text(
                            mangaData.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextConst.headingStyle(16, AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
