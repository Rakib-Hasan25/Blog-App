import 'package:blogapp/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blogapp/core/theme/theme.dart';
import 'package:blogapp/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:blogapp/features/auth/presentation/pages/signin_page.dart';
import 'package:blogapp/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:blogapp/features/blog/presentation/pages/blog_page.dart';
import 'package:blogapp/init_dependecies.main.dart';
import 'package:blogapp/routes/on_generate_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  /*
  runApp() has default widgetbindings but we run extra function
  before runApp() so for safety reasons we explicitly call widget bindings
  */
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => serviceLocator<AppUserCubit>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<BlogBloc>(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // when app run first we call an event which is AuthIsUserLoggedIn()
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: AppTheme.darkThemeMode,
      initialRoute: "/",
      onGenerateRoute: OnGenerateRoute.route,
      routes: {
        "/": (context) {
          return BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) {
              return state is AppUserLoggedIn;
            },
            builder: (context, isLoggedIn) {
              if (isLoggedIn) {
                return const BlogPage();
              }
              return const SignInPage();
            },
          );
        },
      },
    );
  }
}
