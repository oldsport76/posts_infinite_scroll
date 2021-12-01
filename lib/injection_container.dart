import 'package:get_it/get_it.dart';
import 'package:posts_infinite_scroll/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:posts_infinite_scroll/features/posts/data/repositories/post_repository.dart';
import 'package:posts_infinite_scroll/features/posts/domain/repositories/i_post_repository.dart';
import 'package:posts_infinite_scroll/features/posts/domain/usecases/get_posts.dart';

import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  /*sl.registerFactory(
        () => NumberTriviaBloc(
      concrete: sl(),
      inputConverter: sl(),
      random: sl(),
    ),
  );*/

  // Use cases
  sl.registerLazySingleton(() => GetPosts(sl()));

  // Repository
  sl.registerLazySingleton<IPostRepository>(
        () => PostRepository(
      postsRemoteDataSource: sl()
    ),
  );

  // Data sources
  sl.registerLazySingleton<IPostsRemoteDataSource>(
        () => PostsRemoteDataSource(client: sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
}
