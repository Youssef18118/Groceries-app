import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groceries_app/const.dart';
import 'package:groceries_app/helpers/dio_helpers.dart';
import 'package:groceries_app/helpers/hiver_helpers.dart';
import 'package:groceries_app/screens/login/model/loginModel.dart';
import 'package:groceries_app/screens/home/mainScreen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginPasswordVisibilityChanged(isPasswordVisible));
  }


  void login({
  required String email,
  required String password
}) async {
  emit(LoginLoadingState());


  AuthenticationModel model = AuthenticationModel();
  try {
    final response = await DioHelpers.postData(
      path: LoginPath,
      body: {
        "email": email,
        "password": password,
      }
    );


    model = AuthenticationModel.fromJson(response.data);
    if (model.status ?? false) {
      HiveHelpers.setToken(model.data?.token);
      DioHelpers.setToken(model.data?.token ?? '');
      Get.offAll(() => const HomeScreen());
      emit(LoginSucessState());
    } else {
      emit(LogineErrorState(model.message ?? "Error"));
    }

  } catch (e) {
    
    emit(LogineErrorState(e.toString()));
    
  }
}

  
}
