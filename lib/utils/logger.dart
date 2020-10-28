import 'package:flutter/material.dart';
import 'package:flutter_architecture/constants/enums.dart';
import 'package:meta/meta.dart';
import "package:intl/intl.dart";
import "package:flutter/foundation.dart";

initLogger() {
  Logger.addClient(DebugLoggerClient());
}

abstract class LoggerClient {
  onLog({LogLevel level, String message, dynamic e, StackTrace s, Color color});
}

class Logger {
  static final _clients = <LoggerClient>[];

  /// Debug level logs
  static d(
    String message, {
    dynamic e,
    StackTrace s,
  }) {
    _clients.forEach((c) => c.onLog(
          level: LogLevel.debug,
          message: message,
          e: e,
          s: s,
        ));
  }

  // Warning level logs
  static w(
    String message, {
    dynamic e,
    StackTrace s,
  }) {
    _clients.forEach((c) => c.onLog(
          level: LogLevel.warning,
          message: message,
          e: e,
          s: s,
        ));
  }

  /// Error level logs
  /// Requires a current StackTrace to report correctly on Crashlytics
  /// Always reports as non-fatal to Crashlytics
  static e(
    String message, {
    dynamic e,
    StackTrace s,
  }) {
    _clients.forEach((c) => c.onLog(
          level: LogLevel.error,
          message: message,
          e: e,
          s: s,
        ));
  }

  static addClient(LoggerClient client) {
    _clients.add(client);
  }
}

class DebugLoggerClient implements LoggerClient {
  static final dateFormat = DateFormat("HH:mm:ss.SSS");

  String _timestamp() {
    return dateFormat.format(DateTime.now());
  }

  @override
  onLog({
    LogLevel level,
    String message,
    dynamic e,
    StackTrace s,
    Color color,
  }) {
    switch (level) {
      case LogLevel.debug:
        debugPrint('\x1B[94m' + "${_timestamp()} [DEBUG] $message" + '\x1B[4m');
        if (e != null) {
          debugPrint(e.toString());
          debugPrint(s.toString() ?? StackTrace.current);
        }
        break;
      case LogLevel.warning:
        debugPrint(
            '\x1B[33m' + "${_timestamp()} [WARNING] $message" + '\x1B[55m');
        if (e != null) {
          debugPrint(e.toString());
          debugPrint(s.toString() ?? StackTrace.current.toString());
        }
        break;
      case LogLevel.error:
        debugPrint(
            '\x1B[31m' + "${_timestamp()} [DEBUG] $message" + '\x1B[91m');
        if (e != null) {
          debugPrint(e.toString());
        }
        // Errors always show a StackTrace
        if (s != null) {
          debugPrint(s.toString() ?? StackTrace.current.toString());
        }
        break;
    }
  }
}
