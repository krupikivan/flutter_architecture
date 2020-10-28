import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture/auth_repository.dart';
import 'package:flutter_architecture/logic/login/login.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            );
          },
          child: LoginForm(),
        ),
      ),
    );
  }
}
