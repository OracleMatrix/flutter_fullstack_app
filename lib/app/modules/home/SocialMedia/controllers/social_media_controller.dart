import 'package:flutter/material.dart';
import 'package:fullstack_app/app/data/constants.dart';
import 'package:fullstack_app/app/modules/home/SocialMedia/Models/get_all_post_comments_model.dart';
import 'package:fullstack_app/app/modules/home/SocialMedia/Models/get_all_posts_model.dart';
import 'package:fullstack_app/app/modules/home/SocialMedia/providers/add_comment_to_post_provider.dart';
import 'package:fullstack_app/app/modules/home/SocialMedia/providers/delete_post_provider.dart';
import 'package:fullstack_app/app/modules/home/SocialMedia/providers/get_posts_comments_provider.dart';
import 'package:fullstack_app/app/modules/home/SocialMedia/providers/get_posts_provider.dart';
import 'package:fullstack_app/app/modules/home/providers/create_post_provider.dart';
import 'package:get/get.dart';

class SocialMediaController extends GetxController {
  var isLoading = false.obs;
  var isCommentsLoading = false.obs;
  var getAllPostsModel = <GetAllPostsModel>[].obs;
  var getPostsProvider = GetPostsProvider();
  var deletePostProvider = DeletePostProvider();
  var getPostsCommentsProvider = GetPostsCommentsProvider();
  var getAllPostCommentsModel = <GetAllPostCommentsModel>[].obs;
  var addCommentToPostProvider = AddCommentToPostProvider();

  var createPostProvider = CreatePostProvider();

  Future getAllPosts() async {
    try {
      isLoading.value = true;
      final data = await getPostsProvider.getAllPosts();
      if (data != null) {
        getAllPostsModel.value = data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future deletePost(int id) async {
    try {
      isLoading.value = true;
      final data = await deletePostProvider.getAllUsers(id);
      if (data != null) {
        Get.snackbar(
          'Success',
          'Post deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
        getAllPosts();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future getAllPostComments(int id) async {
    try {
      isCommentsLoading.value = true;
      final data = await getPostsCommentsProvider.getAllPosts(id);
      if (data != null) {
        getAllPostCommentsModel.value = data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future createPost(String title, String content) async {
    try {
      isLoading.value = true;
      final id = await Constants.storage.read('id');
      final data = await createPostProvider.createPost(title, content, id);
      if (data != null) {
        Get.back();
        getAllPosts();
        Get.snackbar(
          'Success',
          'Post created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future addCommentToPost({
    required int postId,
    required String content,
  }) async {
    try {
      final userId = await Constants.storage.read('id');
      isCommentsLoading.value = true;
      final data = await addCommentToPostProvider.addComment(
        userId: userId,
        postId: postId,
        content: content,
      );
      if (data != null) {
        Get.snackbar(
          'Success',
          'Comment added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
        );
        getAllPostComments(postId);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isCommentsLoading.value = false;
    }
  }

  @override
  void onInit() {
    getAllPosts();
    super.onInit();
  }
}
