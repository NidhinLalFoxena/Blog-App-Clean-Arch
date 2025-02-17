import 'dart:io';
import 'package:blog_app_cleanarch/core/usecase/usecase.dart';
import 'package:blog_app_cleanarch/features/blog/domain/usecases/get_blogs.dart';
import 'package:blog_app_cleanarch/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      topics: event.topics,
      image: event.image,
    ));

    result.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (success) => emit(BlogUploadSuccess()),
    );
  }

  _onFetchAllBlogs(BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final result = await _getAllBlogs(NoParams());

    result.fold(
      (failure) => emit(BlogFailure(failure.message)),
      (blogs) => emit(BlogDisplaySuccess(blogs)),
    );
  }
}
