import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mochi/app/cubit/auth/auth_cubit.dart';
import 'package:mochi/app/cubit/creds/creds_cubit.dart';
import 'package:mochi/app/cubit/feed/feed_cubit.dart';
import 'package:mochi/data/repos/local_repository_impl.dart';
import 'package:mochi/domain/usecases/user/get_user_usecase.dart';
import 'package:mochi/domain/usecases/user/is_sign_in_usecase.dart';

import 'app/cubit/chapter/chapter_cubit.dart';
import 'app/cubit/manga/manga_cubit.dart';
import 'app/cubit/user/user_cubit.dart';
import 'data/datasource/remote_datasource.dart';
import 'data/datasource/remote_datasource_impl.dart';
import 'domain/repos/local_repository.dart';
import 'domain/usecases/feed/get_all_mangalist_usecase.dart';
import 'domain/usecases/feed/get_latest_arrival_usecase.dart';
import 'domain/usecases/feed/get_mangalist_by_category_usecase.dart';
import 'domain/usecases/feed/get_trending_manga_usecase.dart';
import 'domain/usecases/manga_data/get_chapter_usecase.dart';
import 'domain/usecases/manga_data/get_chapters_usecase.dart';
import 'domain/usecases/manga_data/get_manga_data_usecase.dart';
import 'domain/usecases/user/login_user_usecase.dart';
import 'domain/usecases/user/logout_user_usecase.dart';
import 'domain/usecases/user/register_user_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // cubits
  sl.registerFactory(
    () => FeedCubit(
      getAllMangaListUsecase: sl.call(),
      getTrendingMangaListUsecase: sl.call(),
      getLatestArrivalUsecase: sl.call(),
      getMangaListByCategoryUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => MangaCubit(
      getMangaDataUsecase: sl.call(),
      getChaptersUsecase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => ChapterCubit(
      getChapterUsecase: sl.call(),
    ),
  );

  sl.registerFactory(() => UserCubit(getUserUsecase: sl.call()));

  sl.registerFactory(
    () => AuthCubit(
      signOutUsecase: sl.call(),
      isSignInUsecase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredsCubit(
      registerUserUseCase: sl.call(),
      loginUserUseCase: sl.call(),
    ),
  );

  // usecases
  sl.registerLazySingleton(() => GetAllMangaListUsecase(sl.call()));
  sl.registerLazySingleton(() => GetTrendingMangaListUsecase(sl.call()));
  sl.registerLazySingleton(() => GetLatestArrivalUsecase(sl.call()));
  sl.registerLazySingleton(() => GetMangaListByCategoryUsecase(sl.call()));
  sl.registerLazySingleton(() => GetMangaDataUsecase(sl.call()));
  sl.registerLazySingleton(() => GetChaptersUsecase(sl.call()));
  sl.registerLazySingleton(() => GetChapterUsecase(sl.call()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl.call()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl.call()));
  sl.registerLazySingleton(() => LogoutUserUseCase(sl.call()));
  sl.registerLazySingleton(() => GetUserUsecase(sl.call()));
  sl.registerLazySingleton(() => IsSignInUsecase(sl.call()));

  // repository
  sl.registerLazySingleton<LocalRepository>(
      () => LocalRepositoryImpl(dataSource: sl.call())); // local
  sl.registerLazySingleton<RemoteDataSource>(() =>
      RemoteDataSourceImpl(firestore: sl.call(), auth: sl.call())); // remote
  // datasource
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
}
