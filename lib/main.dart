import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/app/screens/home_screen.dart';
import 'package:mochi/dependency_injection.dart' as di;

import 'app/cubit/chapter/chapter_cubit.dart';
import 'app/cubit/feed/feed_cubit.dart';
import 'app/cubit/manga/manga_cubit.dart';
import 'app/cubit/user/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => di.sl<FeedCubit>()
              ..fetchTrending()
              ..fetchLatest()),
        BlocProvider(create: (_) => di.sl<MangaCubit>()),
        BlocProvider(create: (_) => di.sl<ChapterCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()..appStarted()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
