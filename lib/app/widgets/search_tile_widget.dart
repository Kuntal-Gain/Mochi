import 'package:flutter/material.dart';
import 'package:mochi/domain/entities/manga_entity.dart';

import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import '../../utils/constants/text_constants.dart';

Widget searchTileWidget(MangaEntity manga, BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(Sizes.md),
    height: 230,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.md,
              top: Sizes.md,
              bottom: Sizes.md,
            ),
            child: SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  manga.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  manga.name,
                  style: TextConst.headingStyle(
                    28,
                    AppColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  mergeGenres(manga.genres),
                  style: TextConst.headingStyle(
                    14,
                    AppColors.white,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: manga.chapterList.length < 3
                        ? manga.chapterList.length
                        : 3,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Image.network(
                              'https://cdn-icons-png.flaticon.com/512/17836/17836074.png',
                              height: 25,
                              width: 25,
                              color: AppColors.white,
                            ),
                            Text(
                              manga.chapterList[index]
                                      .replaceAll('chapter-', 'Chap ') +
                                  ' [EN]',
                              style: TextConst.headingStyle(
                                16,
                                AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

String mergeGenres(List<String> genres) {
  return genres.take(3).join(', ');
}
