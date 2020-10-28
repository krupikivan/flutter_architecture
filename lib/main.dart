import 'package:flutter_architecture/user_repository.dart';
import 'package:flutter_architecture/auth_repository.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture/utils/logger.dart';
import 'app.dart';
import 'data/repositories/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /**
   * Initiate Logger to print wathever you want
   */
  initLogger();
  final prefs = Preferences();
  await prefs.initPrefs();

  /**Es muy buena practica inyectar instancias que no dependen de nada
  dentro del main y luego inyectarlo en el app
  **/
  runApp(App(
    authRepository: AuthRepository(),
    userRepository: UserRepository(),
    connectivity: Connectivity(),
  ));
}
