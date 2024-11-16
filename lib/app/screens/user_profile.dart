import 'package:flutter/material.dart';
import 'package:mochi/domain/entities/user_entity.dart';
import 'package:mochi/utils/constants/color_constants.dart';
import 'package:mochi/utils/constants/size_constants.dart';
import 'package:mochi/utils/constants/text_constants.dart';

class UserProfile extends StatefulWidget {
  final UserEntity user;
  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        centerTitle: true,
        title: Text('User Profile',
            style: TextConst.headingStyle(25, AppColors.black)),
      ),
      body: Column(
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: Sizes.xl * 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '@${widget.user.username}',
              style: TextConst.headingStyle(
                20,
                AppColors.primary,
              ),
            ),
          ),
          Text(
            widget.user.email,
            style: TextConst.MediumStyle(
              16,
              AppColors.black,
            ),
          ),
          sizeVer(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              stats('Reading List', widget.user.readingList.length),
              stats('Favourites', widget.user.readingList.length),
              stats('Time Spent', widget.user.timeSpent),
            ],
          ),
          sizeVer(20),
          if (widget.user.readingList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
              child: Text(
                "Continue Reading",
                style: TextConst.headingStyle(Sizes.fontXl, null),
              ),
            ),
          if (widget.user.readingList.isNotEmpty)
            SizedBox(
              height: mq.height * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
                itemCount: 2,
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
        ],
      ),
    );
  }
}

stats(String text, num value) {
  return Container(
    height: 100,
    width: 120,
    decoration: BoxDecoration(
      color: AppColors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(5, 5),
          color: AppColors.primary,
        )
      ],
      border: Border.all(
        color: AppColors.primary,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toString(),
          style: TextConst.headingStyle(25, AppColors.black),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextConst.headingStyle(16, AppColors.primary),
        ),
      ],
    ),
  );
}
