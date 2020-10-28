import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_architecture/constants/enums.dart';
import 'package:flutter_architecture/utils/logger.dart';
import 'package:meta/meta.dart';
import 'package:connectivity/connectivity.dart';
part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetCubit({@required this.connectivity}) : super(InternetLoading()) {
    monitoringInternet();
    // monitorInternetConnection();
  }

  final Connectivity connectivity;

  // StreamSubscription connectivityStream;

  // StreamSubscription<ConnectivityResult> monitorInternetConnection() {
  //   return connectivityStream = monitoringInternet();
  // }

  monitoringInternet() {
    connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi) {
        Logger.d("Internet connected with wifi");
        emitInternetConnected(ConnectionType.wifi);
      } else if (result == ConnectivityResult.mobile) {
        Logger.d("Internet connected with mobile");
        emitInternetConnected(ConnectionType.mobile);
      } else if (result == ConnectivityResult.none) {
        Logger.e("No internet connection");
        emitInternetDisconnected();
      } else {
        Logger.e("Error from the internet connectivity");
      }
    });
  }

  void emitInternetConnected(ConnectionType _connectionType) =>
      emit(InternetConnected(connectionType: _connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    // connectivityStream.cancel();
    return super.close();
  }
}
