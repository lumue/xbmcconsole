import '../xbmcapi.dart';
import 'Session.dart';

class WebsocketXbmcApi extends XbmcApi
{
  
  Session session;
  
  WebsocketXbmcApi(String url)
  {
    session=new Session(url);
    session.open();
    while(!session.isOpen());
  }
  
  @override
  WebsocketVideoLibraryGetMoviesRequest newVideoLibraryGetMoviesRequest() {
    return new WebsocketVideoLibraryGetMoviesRequest();
  }
  
  
}

class WebsocketVideoLibraryGetMoviesRequest implements WebsocketRequest, VideoLibraryGetMoviesRequest {
  @override
  getRequestMessage() {
    // TODO: implement getRequestMessage
  }

  @override
  onMessage(MessageEvent e) {
    // TODO: implement onMessage
  }
}