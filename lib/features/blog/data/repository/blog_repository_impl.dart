import 'dart:io';

import 'package:blog_app_cleanarch/core/error/exeption.dart';
import 'package:blog_app_cleanarch/core/error/failures.dart';
import 'package:blog_app_cleanarch/core/network/connection_checker.dart';
import 'package:blog_app_cleanarch/features/blog/data/datasources/local/local_data_source.dart';
import 'package:blog_app_cleanarch/features/blog/data/datasources/remote/blog_remote_datasource.dart';
import 'package:blog_app_cleanarch/features/blog/data/modal/blog_modal.dart';
import 'package:blog_app_cleanarch/features/blog/domain/entities/blog.dart';
import 'package:blog_app_cleanarch/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        left(left(Failure('No Internet Connection')));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerExeption catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLoacalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerExeption catch (e) {
      return left(Failure(e.message));
    }
  }
}
