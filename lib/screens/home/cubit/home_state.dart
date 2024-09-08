part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeHeartChanged extends HomeState {}



final class HomeScreenChangedState extends HomeState {
  final int selectedIndex;

  HomeScreenChangedState(this.selectedIndex);
}
final class HomeBannerLoadingState extends HomeState {}
final class HomeBannerSuccessState extends HomeState {}
final class HomeBannerErrorState extends HomeState {
  final String? message;
  HomeBannerErrorState(this.message);
}

final class HomeProductLoadingState extends HomeState {}
final class HomeProductSuccessState extends HomeState {}
final class HomeProductErrorState extends HomeState {
  final String? message;
  HomeProductErrorState(this.message);
}

final class HomeProfileLoadingState extends HomeState {}
final class HomeProfileSuccessState extends HomeState {}
final class HomeProfileErrorState extends HomeState {
  final String? message;
  HomeProfileErrorState(this.message);
}

final class HomePasswordLoadingState extends HomeState {}
final class HomePasswordSuccessState extends HomeState {}
final class HomePasswordErrorState extends HomeState {
  final String? message;
  HomePasswordErrorState(this.message);
}

final class HomeCartLoadingState extends HomeState {}
final class HomeCartSuccessState extends HomeState {}
final class HomeCartErrorState extends HomeState {
  final String? message;
  HomeCartErrorState(this.message);
}



final class HomeCartClearedState extends HomeState {}
final class HomeLogoutState extends HomeState {}