import 'package:flutter_architecture/logic/auth/auth.dart';
import 'package:flutter_architecture/utils/locale.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlocBuilder<AuthBloc, AuthState>(
                /** In this situation when user logout bloc 
                   * builder need rebuild without user 
                   * because at this moment user doesn't exist
                 * so we decide when bloc builder want to rebuild.
                 */
                buildWhen: (previous, current) => current.user != null,
                builder: (context, snap) => Text(snap.user.id.toString())),
            RaisedButton(
              onPressed: () {
                context.bloc<AuthBloc>().add(AuthLogoutRequested());
              },
              child: Text(I18n.of(context).msg('logout')),
            ),
          ],
        ),
      ),
    );
  }
}
