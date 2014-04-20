import 'dart:html';
import 'dart:convert';

void main() {

  // import에서 <template>를 복제합니다.
  /*var link = querySelector('link[rel="import"]');  
  var template = link.import.querySelector('#navbar');
  var clone = document.importNode(template.content, true);
  (clone.querySelector('#index') as Element).classes.add('active');
  querySelector('#menu').append(clone);*/

  // var url = 'https://www.googleapis.com/youtube/v3/videos?id=' + '7lCDEYXw3mM' + '&key=' + 'AIzaSyBpaXmomBFMaEB1nYhNrqZEiyPlBL10PYk' + '&part=snippet,contentDetails,statistics,status';

  HttpRequest.getString('links.json').then((content) {

    // Load Data
    List<Map> items = JSON.decode(content);

    var div = querySelector('#content');

    items.forEach((e) {
      
      var panel = new DivElement();
      panel.classes.add("panel panel-primary");
      div.append(panel);
      
      var h = new DivElement();
      h.classes.add('panel-heading');
      h.text = e['category'];
      panel.append(h);

      var ul = new UListElement();
      ul.classes.add('list-group');
      panel.append(ul);
      
      e['items'].forEach((f) {
        var li = new LIElement();
        li.classes.add('list-group-item');
        ul.append(li);

        var ae = new AnchorElement(href: f['url']);
        ae.attributes['target'] = '_blank';
        ae.text = f['title'];
        li.append(ae);
      });
    });
  });
}
