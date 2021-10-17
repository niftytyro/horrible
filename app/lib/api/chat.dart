import 'package:app/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRoom {
  late WebSocketChannel wsChannel;

  ChatRoom(int id) {
    wsChannel = WebSocketChannel.connect(Uri.parse("$websocketUrl/chat/$id/"));
  }

  get stream {
    return wsChannel.stream;
  }

  send(String msg) {
    wsChannel.sink.add(msg);
  }

  close() {
    wsChannel.sink.close();
  }
}
