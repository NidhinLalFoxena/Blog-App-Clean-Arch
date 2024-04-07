import 'dart:developer';
import 'dart:io';

import 'package:blog_app_cleanarch/core/error/exeption.dart';
import 'package:blog_app_cleanarch/features/blog/data/modal/blog_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExeption(e.message);
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('unique_blog_images').upload(
            blog.id,
            image,
          );

      return supabaseClient.storage.from('unique_blog_images').getPublicUrl(
            blog.id,
          );
    } on StorageException catch (e) {
      log(e.toString());
      throw ServerExeption(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles(name)');

      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }
}
