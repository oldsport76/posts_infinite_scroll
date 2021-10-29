import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_infinite_scroll/async_request_status.dart';
import 'package:posts_infinite_scroll/post.dart';
import 'package:posts_infinite_scroll/posts_bloc.dart';
import 'package:posts_infinite_scroll/posts_event.dart';
import 'package:posts_infinite_scroll/posts_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc()..add(PostsFetched()),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PostsScreen(),
      ),
    );
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Posts Infinite Scroll'),
        ),
        body: _body(state),
      );
    });
  }

  Widget _body(PostsState state) {
    if (state.fetchPostsStatus == AsyncRequestStatus.uninitialized) {
      return const Center(
        child: Text('No posts fetched'),
      );
    } else if (state.fetchPostsStatus == AsyncRequestStatus.loading) {
      return _postList(state);
    } else if (state.fetchPostsStatus == AsyncRequestStatus.success) {
      return state.posts.isEmpty
          ? const Center(
              child: Text('There are no posts'),
            )
          : _postList(state);
    } else {
      return const Center(
        child: Text('Failure'),
      );
    }
  }

  Widget _postRow(Post post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('userId: ${post.userId}'),
              Text('id: ${post.id}'),
              Text('title: ${post.title}'),
              Text('body: ${post.body}')
            ],
          ),
        ),
      ),
    );
  }

  Widget _postList(PostsState state) {
    return Stack(
      children: [
        ListView(
          controller: _scrollController,
          children: state.posts.map((e) => _postRow(e)).toList(),
        ),
        if (state.fetchPostsStatus == AsyncRequestStatus.loading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      final _postsBloc = context.read<PostsBloc>();
      _postsBloc.add(PostsFetched());
    }
  }
}
