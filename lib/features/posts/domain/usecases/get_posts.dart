import 'package:equatable/equatable.dart';
import 'package:posts_infinite_scroll/core/usecases/use_case.dart';
import 'package:posts_infinite_scroll/features/posts/domain/entities/post.dart';
import 'package:posts_infinite_scroll/features/posts/domain/repositories/i_post_repository.dart';

class GetPosts implements UseCase<List<Post>, Params> {
  final IPostRepository repository;

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