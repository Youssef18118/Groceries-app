import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:groceries_app/screens/home/cubit/home_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:groceries_app/screens/home/user/userWidgets.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final profile = cubit.Profmodel.data;
    final height = MediaQuery.sizeOf(context).height;

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if(state is HomePasswordErrorState){
          Get.snackbar("Error", state?.message ?? "Error in changing password", backgroundColor: Colors.red, colorText: Colors.black);
        }
        if(state is HomeProfileErrorState){
          Get.snackbar("Error", state?.message ?? "Error in Profile Data", backgroundColor: Colors.red, colorText: Colors.black);
        }

        if(state is HomePasswordSuccessState){
          Get.snackbar("Success", "Password Changed Successfully", backgroundColor: Colors.green, colorText: Colors.white);
        }

        if(state is HomeProfileSuccessState){
          Get.snackbar("Success", "Profile Changed Successfully", backgroundColor: Colors.green, colorText: Colors.white);
        }
        
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeProfileLoadingState) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (profile == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text("No profile data available."),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        child: CachedNetworkImage(
                          imageUrl: profile.image ?? '', 
                          imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 50,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(), 
                          errorWidget: (context, url, error) => const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                                'assets/images/no_image.png'), 
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Name: ${profile.name ?? 'N/A'}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: ${profile.email ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone: ${profile.phone ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.2,),
                    ElevButton("Change Password", false, context, isChangePassword:true),
                    const SizedBox(height: 10),
                    ElevButton("Update Profile", false, context),
                    const SizedBox(height: 10),
                    ElevButton("Logout", true, context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  
}
