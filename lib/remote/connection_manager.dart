import 'dart:developer' as developer;
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionManager {
  static const _ws = 'ws://10.0.2.2:2307';

  WebSocketChannel? channel;

  bool get connected => channel != null;

  Stream? get stream => channel?.stream;

  Future<bool> connect() async {
    developer.log(
      'Attempting to connect websocket',
      name: 'Remote:connect',
    );
    if (channel == null) {
      late final Uri uri;
      try {
        uri = Uri.parse(_ws);
      } on Exception {
        developer.log(
          'Failed to parse websocket address',
          name: 'Remote:connect',
        );
        return false;
      }
      try {
        channel = WebSocketChannel.connect(uri);
      } on Exception {
        developer.log(
          'Exception sending websocket connection requests',
          name: 'Remote:connect',
        );
        return false;
      }
    }

    late final bool connectedStatus;
    try {
      connectedStatus = await Future.any([
        Future.sync(() async {
          await channel!.ready;
          return true;
        }),
        Future.delayed(
          const Duration(seconds: 2),
          () => false,
        ),
      ]);
    } on Exception {
      developer.log(
        'Exception connecting the websocket',
        name: 'Remote:connect',
      );
      return false;
    }

    if (!connectedStatus) {
      developer.log(
        'Connection timeout expired; Cancelling connection',
        name: 'Remote:connect',
      );
      try {
        channel!.sink.close();
      } on Exception {
        developer.log(
          'Exception closing the channel sink; Cancelling connection anyway',
          name: 'Remote:connect',
        );
      } finally {
        channel = null;
      }
    } else {
      developer.log(
        'Connection of websocket successful',
        name: 'Remote:connect',
      );
    }
    return connectedStatus;
  }

  Future<void> disconnect() async {
    developer.log(
      'Attempting to disconnect websocket',
      name: 'Remote:disconnect',
    );
    if (channel == null) {
      developer.log(
        'Failed to disconnect websocket: the channel is already null',
        name: 'Remote:disconnect',
      );
      return;
    }
    try {
      await channel!.sink.close();
    } on Exception {
      developer.log(
        'Exception while closing channel sink; closing connection anyway',
        name: 'Remote:disconnect',
      );
    } finally {
      channel = null;
    }
  }
}
