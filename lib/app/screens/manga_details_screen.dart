import 'package:flutter/material.dart';
import 'package:mochi/utils/constants/size_constants.dart';
import 'package:mochi/utils/constants/text_constants.dart';

import '../../domain/entities/manga_entity.dart';
import '../../utils/constants/color_constants.dart';
import 'chapter_screen.dart';

class MangaDetailsScreen extends StatefulWidget {
  const MangaDetailsScreen(
      {super.key, required this.manga, required this.mangaId});

  final MangaEntity manga;
  final String mangaId;

  @override
  State<MangaDetailsScreen> createState() => _MangaDetailsScreenState();
}

class _MangaDetailsScreenState extends State<MangaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(widget.manga.name.toUpperCase(),
              style: TextConst.headingStyle(20, AppColors.black)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizeVer(12),
              Center(
                child: Container(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(widget.manga.imageUrl),
                  ),
                ),
              ),
              sizeVer(16),
              Center(
                child: Text(
                  widget.manga.name,
                  textAlign: TextAlign.center,
                  style: TextConst.headingStyle(
                    30,
                    AppColors.black,
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.manga.author.toUpperCase(),
                  style: TextConst.MediumStyle(
                    16,
                    AppColors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChapterScreen(
                                    chapterId: widget.manga.chapterList[0],
                                    mangaId: widget.mangaId,
                                  )),
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChapterScreen(
                                      chapterId: widget.manga.chapterList[
                                          widget.manga.chapterList.length - 1],
                                      mangaId: widget.mangaId,
                                    )),
                          );
                        },
                        child: Container(
                          height: 60,
                          width: 150,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Read Now',
                              style: TextConst.headingStyle(
                                18,
                                AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    sizeHor(12),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xffc2c2c2)),
                      ),
                      child: IconButton(
                        onPressed: () {
                          print('bookmark');
                        },
                        icon: Icon(
                          Icons.bookmark_border,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  spacing: 3,
                  children: widget.manga.genres.map((genre) {
                    return Chip(
                      backgroundColor: AppColors.white,
                      label: Text(
                        genre,
                        style: TextConst.headingStyle(
                          12,
                          AppColors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              mangaDetailsTile("Status", widget.manga.status),
              mangaDetailsTile(
                  "Last Update", formatDateTime(widget.manga.updated)),
              mangaDetailsTile("Views", widget.manga.view),
              if (widget.manga.chapterList.isNotEmpty)
                Container(
                  height: widget.manga.chapterList.length < 5
                      ? 5 * 45
                      : 400, // Fixed height for chapter list
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.manga.chapterList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.menu_book_rounded,
                                color: AppColors.black,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterScreen(
                                      chapterId:
                                          widget.manga.chapterList[index],
                                      mangaId: widget.mangaId,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                widget.manga.chapterList[index],
                                style: TextConst.headingStyle(
                                  16,
                                  AppColors.black,
                                ),
                              ),
                            ),
                            Divider(
                              color: AppColors.black,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
        ));
  }
}

Widget mangaDetailsTile(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Text(
          '$title : ',
          style: TextConst.headingStyle(
            16,
            AppColors.black,
          ),
        ),
        Text(
          value,
          style: TextConst.MediumStyle(
            16,
            AppColors.black,
          ),
        ),
      ],
    ),
  );
}

String formatDateTime(String dateStr) {
  try {
    // Parse the date string
    List<String> parts = dateStr.split(' - ');
    String datePart = parts[0];
    String hourPart = parts[1];

    return "$datePart at ${hourPart.padLeft(2, '0')}:00"; // Adds minutes for better readability
  } catch (e) {
    return dateStr; // Return original string if parsing fails
  }
}
