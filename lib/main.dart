import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/app/cubit/auth/auth_cubit.dart';
import 'package:mochi/app/cubit/creds/creds_cubit.dart';
import 'package:mochi/app/screens/home_screen.dart';
import 'package:mochi/dependency_injection.dart' as di;

import 'app/cubit/chapter/chapter_cubit.dart';
import 'app/cubit/feed/feed_cubit.dart';
import 'app/cubit/manga/manga_cubit.dart';
import 'app/cubit/user/user_cubit.dart';
import 'app/screens/auth_screen.dart';
import 'app/screens/splash_screen.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(
            create: (_) => di.sl<FeedCubit>()
              ..fetchTrending()
              ..fetchLatest()),
        BlocProvider(create: (_) => di.sl<MangaCubit>()),
        BlocProvider(create: (_) => di.sl<ChapterCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<CredsCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return HomeScreen(uid: state.uid);
            } else if (state is NotAuthenticated) {
              return const SplashScreen();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
