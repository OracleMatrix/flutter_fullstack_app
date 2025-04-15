// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:fullstack_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fullstack App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SOCIAL_MEDIA);
            },
            icon: Icon(Icons.group),
          ),
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'Logout',
                middleText: 'Are you sure you want to logout?',
                textCancel: 'Cancel',
                textConfirm: 'Logout',
                onConfirm: () {
                  controller.logout();
                },
              );
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.userData.value.name == null) {
          return Center(
            child: Text(
              'No user data available',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.person, size: 70),
                ),
              ),
            ),
            Text(
              '${controller.userData.value.name}',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${controller.userData.value.email}',
              style: TextStyle(
                color: Colors.green,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    final formKey = GlobalKey<FormState>();
                    showModalBottomSheet(
                      enableDrag: true,
                      showDragHandle: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: Get.height * 0.8,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller:
                                          controller.nameController.value,
                                      decoration: InputDecoration(
                                        hintText: 'Name',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller:
                                          controller.emailController.value,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        } else if (!value.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        if (!value.endsWith('.com')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      obscureText: true,
                                      controller:
                                          controller.passwordController.value,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        } else if (value.length < 8) {
                                          return 'Password must be at least 8 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      width: Get.width * 0.4,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            controller.updateUserData();
                                            Get.back();
                                          }
                                        },
                                        child: Text(
                                          'Update',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  label: Text('Edit', style: TextStyle(color: Colors.blue)),
                  icon: Icon(Icons.edit),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Delete',
                      middleText: 'Are you sure you want to delete this user?',
                      textCancel: 'Cancel',
                      cancel: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Cancel'),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      textConfirm: 'Delete',
                      confirmTextColor: Colors.red,
                      confirm: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Delete'),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      onConfirm: () {
                        controller.deleteUser();
                      },
                    );
                  },
                  label: Text('Delete', style: TextStyle(color: Colors.red)),
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        );
      }),
      // refresh floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.getCurrentUserData();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
