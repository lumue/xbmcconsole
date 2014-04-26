import 'dart:html';
import 'dart:convert';

class ResultView {
  Element pageForwardElement;

  Element pageBackElement;

  Element tableBodyElement;

  ResultViewModel model;

  Element templateRowElement;

  ResultView(Element element) {
    this.tableBodyElement = element.querySelector("#result_body");
    Element trElement = tableBodyElement.querySelector("tr");
    this.templateRowElement = trElement.clone(true);
    trElement.hidden = true;
    this.pageBackElement = element.querySelector("#result_pager_back");
    this.pageForwardElement = element.querySelector("#result_pager_forward");
  }

  bindModel(ResultViewModel model) {
    this.model = model;
  }

  update() {
    clearView();
    model.queryResult.forEach((item) {
      Element rowElement = templateRowElement.clone(true);
      var nameCell = rowElement.querySelector("#result_item_name");
      nameCell.text = item.name;
      var typeCell = rowElement.querySelector("#result_item_type");
      typeCell.text = item.type;
      this.tableBodyElement.append(rowElement);
    });
  }

  clearView() {
    tableBodyElement.children.clear();
  }
}

class ViewController {
  ResultView view;
  ResultViewModel model;

  init(Element content) {
    this.view = new ResultView(content);
    this.model = new ResultViewModel();
    this.view.bindModel(model);
    this.view.pageForwardElement.onClick.listen((e) {
      this.pageForward();
    });
    this.view.pageBackElement.onClick.listen((e) {
      this.pageBack();
    });

  }

  loadElements() {
    var to = (this.model.start + this.model.pagesize);
    String url = "http://192.168.1.106:8080/jsonrpc?request={\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"VideoLibrary.GetMovies\"}";
    HttpRequest.getString(url).then((String result) {
      model.queryResult = this.parseResult(result);
      onElementsLoaded();
    });
  }

  List<Item> parseResult(String json) {


    var result = JSON.decode(json);
    result = result["result"];
    var limits = result["limits"];
    var movies = result["movies"];
    int resultSize = limits["total"];
    List<Item> ret = new List(resultSize);
    int i = 0;
    movies.forEach((Map map) {
      ret[i++] = new Item(map["label"], map["movieid"].toString());
    });

    return ret;
  }

  pageForward() {
    model.start += model.pagesize;
    loadElements();
  }

  pageBack() {
    if (model.start >= model.pagesize) {
      model.start -= model.pagesize;
      loadElements();
    }
  }

  onElementsLoaded() {
    view.update();
  }
}

class ResultViewModel {
  int start = 0;
  int pagesize = 20;
  List<Item> queryResult;
}

class Item {
  String name;
  String type;

  Item(String name, String type) {
    this.name = name;
    this.type = type;
  }

}

void main() {
  ViewController controller = new ViewController();
  controller.init(querySelector("#content"));
  controller.loadElements();
}
