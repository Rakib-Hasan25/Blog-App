import 'package:blogapp/core/error/exceptions.dart';
import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDateSource {
  Session? get currentUserSession; // superbase give us session

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?>
      getCurrentUserData(); // we mignt not get the current usedate so , i give nullable usermodel

      Future<void> logout();  
}

class AuthRemoteDataSourceImpl implements AuthRemoteDateSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  Session? get currentUserSession =>
      supabaseClient.auth.currentSession; // superbase auth has currentsession

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );

        /*
        from 'profiles' class we select all the specfic user which id matches with the
        currenentUsersession id 

        but user data has only name and id beacause in profiles we only save the name and id;
        */

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
        /*
        UserModel.fromJson(userData.first) it give the specific user model
        and then we add email in this model with "copy with" function
        */
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> logout() async{
    try{
      final response = await supabaseClient.auth.signOut();
    }catch (e) {
      throw ServerException(e.toString());
    }
   
 
  }
}
