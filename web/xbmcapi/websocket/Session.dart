import 'dart:html';

class Session {

  String url;
  WebSocket socket = null;
  static final int sessionstate_closed = 0,
      sessionstate_opening = 1,
      sessionstate_open = 2,
      sessionstate_closing = 3;
  int status = sessionstate_closed;

  Session(String url) {
    this.url = url;
  }


  execute(WebsocketRequest request) {
    WebSocket ws = getSocket();
    ws.onMessage.listen((MessageEvent e) {
      request.onMessage(e);
    });
    ws.send(request.getRequestMessage());
  }

  WebSocket getSocket() {
    if (socket == null) throw new SessionClosedException();
    return socket;
  }

  open() {
    if (!isClosed()) throw new SessionOpeningException("session must be in closed state");

    status = sessionstate_opening;

    socket = new WebSocket(url);
    socket.onOpen.listen((MessageEvent e) {
      status = sessionstate_open;
    });
    
  }
  
  close()
  {
    if(!isOpen())
    {
      throw new SessionClosingException("session must be in open state");
    }
    
    status=sessionstate_closing;
    
    socket.onClose.listen((CloseEvent e){
      status=sessionstate_closed;
    });
    
    socket.close();
    
  }
  
  isOpen() {
    return status==sessionstate_open;
  }

  bool isClosed() {
    return status == sessionstate_closed;
  }


}

class SessionClosingException extends SessionException{
  SessionClosingException(String s) {
  }
  
}

class SessionOpeningException extends SessionException{
  SessionOpeningException(String s) {
  }
  
}

class SessionClosedException extends SessionException{
}

class SessionException {
  
  String message;
  
  SessionOpeningException(String message) {
    this.message = message;
  }
}






abstract class WebsocketRequest {

  onMessage(MessageEvent e) {
  }
  
  getRequestMessage() {
  }
}
