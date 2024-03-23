import 'package:blogapp/core/constants/Constants.dart';
import 'package:blogapp/features/auth/presentation/pages/signin_page.dart';
import 'package:blogapp/features/auth/presentation/pages/signup_page.dart';
import 'package:blogapp/features/blog/domain/entities/blog.dart';
import 'package:blogapp/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blogapp/features/blog/presentation/pages/blog_page.dart';
import 'package:blogapp/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

class OnGenerateRoute {


  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      
      case Constants.signInPage: {
        return materialPageBuilder(const SignInPage());

      }
      case Constants.signUpPage: {
        return materialPageBuilder(const SignUpPage());

      }
      case Constants.blogPage: {
        return materialPageBuilder(const BlogPage());

      }
      case Constants.blogViewerPage: {
        if (args is Blog) {
           return materialPageBuilder( BlogViewerPage(blog: args));
        }
        else {
          return materialPageBuilder( const ErrorPage());
        }

      }
      case Constants.addNewBlogPage: {
        return materialPageBuilder(const AddNewBlogPage());

      }
       
      }
    return null;

     
      
      // case PageConst.singleChatPage: {
      //   if(args is MessageEntity) {
      //     return materialPageBuilder( SingleChatPage(message: args));
      //   } else {
      //     return materialPageBuilder( const ErrorPage());
      //   }

      // }
    }


   }

  

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text("Error"),
      ),
    );
  }
}