// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:fullstack_app/app/data/constants.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/social_media_controller.dart';

class SocialMediaView extends GetView<SocialMediaController> {
  const SocialMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();
    final id = Constants.storage.read('id');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                enableDrag: true,
                context: Get.context!,
                builder: (context) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: Get.height * 0.8,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.post_add,
                                      color: Colors.deepPurple,
                                      size: 100,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a title';
                                      }
                                      return null;
                                    },
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Title',
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a description';
                                      }
                                      return null;
                                    },
                                    maxLines: 10,
                                    controller: _contentController,
                                    decoration: InputDecoration(
                                      hintText: 'Description',
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(
                                    () => MaterialButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          controller.createPost(
                                            _titleController.text,
                                            _contentController.text,
                                          );
                                        }
                                      },
                                      minWidth: Get.width * 0.4,
                                      shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Colors.blue,
                                      child:
                                          controller.isLoading.value
                                              ? Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                              : Text('Send post'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.post_add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getAllPosts(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.getAllPostsModel.isEmpty) {
            return const Center(child: Text('No data found'));
          }
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: controller.getAllPostsModel.length,
            itemBuilder: (context, index) {
              final data = controller.getAllPostsModel[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(child: Icon(Icons.person)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(data.name ?? 'Unknown'),
                                ),
                                Text(data.email ?? 'Unknown'),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            timeago.format(data.createdAt ?? DateTime.now()),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        data.title!,
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                      subtitle: Text(data.content!),
                    ),
                    if (data.userId == id) Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (data.userId == id)
                          TextButton.icon(
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Delete Post',
                                middleText:
                                    'Are you sure you want to delete this post?',
                                onConfirm: () {
                                  controller.deletePost(data.id!);
                                  Get.back();
                                },
                                onCancel: () {
                                  Get.back();
                                },
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                            label: Text('Delete post'),
                          ),
                        TextButton.icon(
                          onPressed: () {
                            controller.getAllPostComments(data.id!);
                            final _formKey = GlobalKey<FormState>();
                            final TextEditingController _commentController =
                                TextEditingController();
                            showModalBottomSheet(
                              showDragHandle: true,
                              isScrollControlled: true,
                              enableDrag: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: SizedBox(
                                      height: Get.height * 0.7,
                                      child: Obx(() {
                                        if (controller
                                            .isCommentsLoading
                                            .value) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        return Column(
                                          children: [
                                            Expanded(
                                              child:
                                                  controller
                                                          .getAllPostCommentsModel
                                                          .isEmpty
                                                      ? Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .comments_disabled_outlined,
                                                              size: 50,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Text(
                                                              'No comments found',
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                      : ListView.builder(
                                                        itemCount:
                                                            controller
                                                                .getAllPostCommentsModel
                                                                .length,
                                                        itemBuilder: (
                                                          context,
                                                          index,
                                                        ) {
                                                          final comment =
                                                              controller
                                                                  .getAllPostCommentsModel[index];
                                                          return Column(
                                                            children: [
                                                              ListTile(
                                                                leading: const CircleAvatar(
                                                                  child: Icon(
                                                                    Icons
                                                                        .person,
                                                                  ),
                                                                ),
                                                                title: Text(
                                                                  comment.name ??
                                                                      '',
                                                                ),
                                                                subtitle: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      comment.content ??
                                                                          '',
                                                                      style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      timeago.format(
                                                                        comment.createdAt ??
                                                                            DateTime.now(),
                                                                      ),
                                                                      style: const TextStyle(
                                                                        color:
                                                                            Colors.grey,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Divider(),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: TextFormField(
                                                validator:
                                                    (value) =>
                                                        value == null ||
                                                                value.isEmpty
                                                            ? 'Please enter a comment'
                                                            : null,
                                                controller: _commentController,
                                                decoration: InputDecoration(
                                                  hintText: 'Add a comment',
                                                  border:
                                                      const OutlineInputBorder(),
                                                  filled: true,
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        controller.addCommentToPost(
                                                          postId: data.id!,
                                                          content:
                                                              _commentController
                                                                  .text,
                                                        );
                                                        _commentController
                                                            .clear();
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.send,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.comment, color: Colors.grey),
                          label: Text('Comments'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
