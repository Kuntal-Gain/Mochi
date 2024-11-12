import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/domain/entities/feed_entity.dart';

import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import '../../utils/constants/text_constants.dart';
import '../cubit/manga/manga_cubit.dart';
import '../screens/manga_details_screen.dart';

Widget sliderCardWidget(List<FeedEntity> mangaList) {
  return Container(
    height: 200,
    margin: EdgeInsets.symmetric(vertical: Sizes.md),
    child: StatefulBuilder(
      builder: (context, setState) {
        PageController _pageController = PageController(viewportFraction: 0.8);

        // Auto slide timer
        Future.delayed(Duration.zero, () {
          Timer.periodic(Duration(seconds: 3), (timer) {
            if (_pageController.hasClients) {
              if (_pageController.page == 7) {
                _pageController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            }
          });
        });

        return PageView.builder(
          controller: _pageController,
          itemCount: 10,
          itemBuilder: (ctx, idx) {
            final promo = mangaList[idx];

            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                    image: DecorationImage(
                      image: NetworkImage(promo.image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: Transform.rotate(
                    angle:
                        15 * (3.14159 / 180), // Convert 45 degrees to radians
                    child: Container(
                      height: 150,
                      width: 100,
                      child: Image.network(promo.image),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<MangaCubit>()
                          .getMangaDataUsecase(promo.id)
                          .then((manga) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MangaDetailsScreen(
                              manga: manga,
                              mangaId: promo.id,
                            ),
                          ),
                        );
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(Sizes.borderRadiusLg),
                      ),
                      child: Center(
                        child: Text(
                          'Read',
                          style: TextConst.headingStyle(
                            16,
                            AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.55, // Limit width to 60% of screen
                    child: Text(
                      promo.title,
                      maxLines: 3,
                      style: TextConst.headingStyle(28, AppColors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
  );
}
