import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/utils/constants/size_constants.dart';
import 'package:mochi/utils/constants/text_constants.dart';
import 'package:page_flip/page_flip.dart';

import '../../utils/constants/color_constants.dart';
import '../cubit/chapter/chapter_cubit.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({
    super.key,
    required this.chapterId,
    required this.mangaId,
  });
  final String chapterId;
  final String mangaId;

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  late String currentChapterId;

  @override
  void initState() {
    super.initState();
    currentChapterId = widget.chapterId;
    context.read<ChapterCubit>().getChapter(
          chapterId: currentChapterId,
          mangaId: widget.mangaId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.white,
        title: Text(
          currentChapterId.toUpperCase(),
          style: TextConst.headingStyle(
            20,
            AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<ChapterCubit, ChapterState>(
        builder: (context, state) {
          if (state is ChapterInitial || state is ChapterLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChapterLoaded) {
            final chapter = state.chapter;
            final currentChapterIndex =
                chapter.chapterIds.indexOf(currentChapterId);

            return PageFlipWidget(
              key: _controller,
              backgroundColor: Colors.white,
              lastPage: Container(
                color: const Color(0xff1f1f1f),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'End of Chapter',
                        style: TextConst.headingStyle(20, AppColors.white),
                      ),
                      sizeVer(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (currentChapterIndex <
                              chapter.chapterIds.length - 1)
                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primary,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    currentChapterId = chapter
                                        .chapterIds[currentChapterIndex + 1];
                                  });
                                  context.read<ChapterCubit>().getChapter(
                                        chapterId: currentChapterId,
                                        mangaId: widget.mangaId,
                                      );
                                },
                                child: Text(
                                  'Prev Chapter',
                                  style: TextConst.headingStyle(
                                      16, AppColors.white),
                                ),
                              ),
                            ),
                          sizeHor(12),
                          if (currentChapterIndex > 0)
                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primary,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    currentChapterId = chapter
                                        .chapterIds[currentChapterIndex - 1];
                                  });
                                  context.read<ChapterCubit>().getChapter(
                                        chapterId: currentChapterId,
                                        mangaId: widget.mangaId,
                                      );
                                },
                                child: Text(
                                  'Next Chapter',
                                  style: TextConst.headingStyle(
                                      16, AppColors.white),
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              children: [
                for (final imageUrl in chapter.imageUrls)
                  InteractiveViewer(
                    minScale: 0.5, // Allow zooming out
                    maxScale: 5.0, // Increased max zoom
                    boundaryMargin:
                        EdgeInsets.all(20), // Add margin for panning
                    panEnabled: true, // Enable panning
                    scaleEnabled: true, // Enable scaling/zooming
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                        sizeVer(12),
                        Text(
                          'Page ${chapter.imageUrls.indexOf(imageUrl) + 1} of ${chapter.imageUrls.length}',
                          style: TextConst.headingStyle(16, AppColors.black),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
