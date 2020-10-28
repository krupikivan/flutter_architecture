import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture/auth_repository.dart';
import 'package:flutter_architecture/logic/internet/internet_cubit.dart';
import 'package:flutter_architecture/user_repository.dart';
import 'constants/enums.dart';
import 'data/models/routes.dart';
import 'logic/auth/auth.dart';
import 'views/screens/home/home_page.dart';
import 'views/screens/login/login_page.dart';
import 'views/screens/splash_page.dart';
import 'views/style/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.connectivity,
    @required this.authRepository,
    @required this.userRepository,
  })  : assert(authRepository != null),
        assert(userRepository != null),
        assert(connectivity != null),
        super(key: key);

  final AuthRepository authRepository;
  final UserRepository userRepository;
  final Connectivity connectivity;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      /** We inyect the only instance of AuthBloc to provide 
       * entire widget above and we do that in the main widget
       * to use it throughout the life cycle app
       * */
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(
                  authRepository: authRepository,
                  userRepository: userRepository)),
          /** To manage internet connection we use BlocListener because 
           * it works as a stream with the differences that in this 
           * situation is it not neccesary to repaint the widgets 
           * without any sense          
          * */
          BlocProvider<InternetCubit>(
              create: (_) => InternetCubit(connectivity: connectivity)),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  static final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) => null,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthStatus.authenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    HomePage.route(),
                    (route) => false,
                  );
                  break;
                case AuthStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(),
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (settings) => PageRouteBuilder(
          pageBuilder: (context, _, __) {
            if (settings.name == Routes.initial) {
              return SplashPage();
            } else {
              return _routes[settings.name](context);
            }
          },
          settings: settings,
          transitionsBuilder: (_, animation1, __, child) => FadeTransition(
            opacity: animation1,
            child: child,
          ),
        ),
      ),
    );
  }
}

final _routes = {
  Routes.login: (context) => LoginPage(),
  Routes.home: (context) => HomePage(),
  Routes.splash: (context) => SplashPage(),
};
