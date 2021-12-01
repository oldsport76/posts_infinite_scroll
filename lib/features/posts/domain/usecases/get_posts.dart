import 'package:equatable/equatable.dart';
import 'package:posts_infinite_scroll/core/usecases/use_case.dart';
import 'package:posts_infinite_scroll/features/posts/data/repositories/post_repository.dart';
import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';

class GetPosts implements UseCase<List<Post>, Params> {
  final PostRepository repository;

  GetPosts(this.repository);

  @override
  Future<List<Post>> call(Params params) async {
    return await repository.getPostsPage(params.pageNumber);
  }
}

class Params extends Equatable {
  final int pageNumber;

  const Params({required this.pageNumber});

  @override
  List<Object> get props => [pageNumber];
}