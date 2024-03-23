import 'package:blogapp/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
      // it means logout AppUserInitial()
    } else {
      emit(AppUserLoggedIn(user));
    }
  }
}



// we use AppUser Cubit globally because we might need to 
// check authentication in different places of the application
// not in the auth feature