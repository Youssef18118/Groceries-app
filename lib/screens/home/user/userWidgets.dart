import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:groceries_app/helpers/hiver_helpers.dart';
import 'package:groceries_app/screens/login/Login.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';

Widget ElevButton(String text, bool isLogout, BuildContext context, {bool isChangePassword = false}) {
  return Center(
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (isLogout) {
            HiveHelpers.clearToken();
            context.read<HomeCubit>().resetNavigationIndex();
            Get.offAll(() => const Login());
          } else if (isChangePassword) {
            _showPasswordDialog(context);
          } else {
            _showUpdateProfileDialog(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isLogout ? Colors.red : Colors.blue[300],
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    ),
  );
}



void _showUpdateProfileDialog(BuildContext context) {
  final cubit = context.read<HomeCubit>();
  final profile = cubit.Profmodel.data;

  final nameController = TextEditingController(text: profile?.name);
  final emailController = TextEditingController(text: profile?.email);
  final phoneController = TextEditingController(text: profile?.phone);
  final imageController = TextEditingController(text: profile?.image);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              cubit.updateProfile(
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
                image: imageController.text,
              );
              Navigator.pop(context); 
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showPasswordDialog(BuildContext context) {
  final cubit = context.read<HomeCubit>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Password'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: const InputDecoration(labelText: 'Old Password'),
              ),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              cubit.changePassword(
                  current_password: oldPasswordController.text,
                  new_password: newPasswordController.text);
              Navigator.pop(context); 
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}