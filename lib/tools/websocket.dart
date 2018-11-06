import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

WebSocketsNotifications sockets = new WebSocketsNotifications();

const String SERVER_ADDRESS = "ws://iafoosball.aau.dk:9003";

class WebSocketsNotifications {

  String path = "";

  static final WebSocketsNotifications sockets = new WebSocketsNotifications.internal();

  factory WebSocketsNotifications(){
    return sockets;
  }

  WebSocketsNotifications.internal();

  /// The WebSocket "open" channel
  /// 
  IOWebSocketChannel channel;
  /// Is the connection established?
  ///
  bool isOn = false;
  /// List of methods to be called when a new message
  /// comes in.
  ///
  ObserverList<Function> listeners = new ObserverList<Function>();

  initCommunication() async {
    print("init socket");
    ///
    /// Just in case, close any previous communication
    ///
    reset();
    print(SERVER_ADDRESS+path);

    try {
      
      channel = new IOWebSocketChannel.connect(SERVER_ADDRESS+path);

      ///
      /// Start listening to new notifications / messages
      ///
      channel.stream.listen(
		onReceptionOfMessageFromServer,
		onError: (error, StackTrace stackTrace){
			print("Error2 "+error);
		},
		onDone: (){
			// communication has been closed
			isOn = false;
		}	
	  );
    } catch(e){
      print("Error1 "+e.toString());
      /// General error handling
      /// TODO
    }
  }

  setPath(String path){
    if(path != null){
      print("Path "+path);
      this.path = path;
    }
  }

  reset(){
    if (channel != null){
      if (channel.sink != null){
        channel.sink.close();
        isOn = false;
      }
    }
  }

  sendMessage(String message){
    if (channel != null){
      if (channel.sink != null && isOn){
        channel.sink.add(message);
      }
    }
  }

  addListener(Function callback){
    listeners.add(callback);
  }
  removeListener(Function callback){
    listeners.remove(callback);
  }

  onReceptionOfMessageFromServer(message){
    listeners.forEach((Function callback){
      print(message);
      callback(message);
    });
  }
}