import 'dart:html';
import 'dart:convert';
import 'dart:js';

List<Map> items;

void main() {

  // import에서 <template>를 복제합니다.
  /*var link = querySelector('link[rel="import"]');  
  var template = link.import.querySelector('#navbar');
  var clone = document.importNode(template.content, true);
  (clone.querySelector('#index') as Element).classes.add('active');
  querySelector('#menu').append(clone);*/

  // var url = 'https://www.googleapis.com/youtube/v3/videos?id=' + '7lCDEYXw3mM' + '&key=' + 'AIzaSyBpaXmomBFMaEB1nYhNrqZEiyPlBL10PYk' + '&part=snippet,contentDetails,statistics,status';

  HttpRequest.getString('videos.json').then((content) {

    // Load Data
    items = JSON.decode(content);

    print("Load Data Complete...");

    // only Magicians
    items.retainWhere((e) {
      return e['magician'] != null && e['magician'] != '';
    });

    // Add Document
    items.forEach((e) {
      context['index'].callMethod('add', [new JsObject.jsify({
          "id": e['id'],
          "title": e['title'],
          "category": e['category']
        })]);
    });
    
    // 
    var magicians = new Map<String, List<String>>();
    items.forEach((e) {
      magicians.putIfAbsent(e['magician'], () => new List());
      magicians[e['magician']].add(e['id']);
    });

    // Sort
    List<String> names = magicians.keys.toList()..sort((x, y) {
      return x.compareTo(y);
    });

    // Debug
    print("List Magicians...");
    var sb = new StringBuffer();
    names.forEach((e) {
      sb.write(e);
    });
    print(sb.toString());

    // Add Name
    names.forEach((n) {

      // Name
      var ae2 = new AnchorElement(href: '#' + n.replaceAll(' ', '_'));
      ae2.attributes['data-toggle'] = 'collapse';
      ae2.attributes['data-parent'] = '#accordion';
      ae2.text = n;

      var h4 = new HeadingElement.h4();
      h4.classes.add('panel-title');
      h4.children.add(ae2);

      // Count
      var se = new SpanElement();
      se.classes.add('badge pull-right');
      se.text = magicians[n].length.toString();
      h4.children.add(se);      

      var phDiv = new DivElement();
      phDiv.classes.add('panel-heading');
      phDiv.children.add(h4);
            
      var ul = new UListElement();
      magicians[n].forEach((e) {
        var li = createListItem(getItem(e));
        ul.children.add(li);
      });
      
      var ctDiv = new DivElement();
      ctDiv.classes.add('content cf');
      ctDiv.children.add(ul);
      
      var pbDiv = new DivElement();
      pbDiv.classes.add('panel-body center-block');
      pbDiv.children.add(ctDiv);

      var pcDiv = new DivElement();
      pcDiv.id = n.replaceAll(' ', '_');
      pcDiv.classes.add('panel-collapse collapse');
      pcDiv.children.add(pbDiv);

      var pdDiv = new DivElement();
      pdDiv.classes.add('panel panel-default');
      pdDiv.children.add(phDiv);
      pdDiv.children.add(pcDiv);
      
      querySelector('#accordion').children.add(pdDiv);
    });
  });
}

Map getItem(String id) {
  return items.firstWhere((E) => E['id'] == id);
}

Element createListItem(Map info) {

  var li = new LIElement();

  var a = new AnchorElement(href: 'http://youtu.be/' + info['id']);
  a.attributes['target'] = '_blank';

  var p = new ParagraphElement();
  p.text = info['title'];

  var img = new ImageElement(src: 'http://i1.ytimg.com/vi/' + info['id'] +
      '/mqdefault.jpg');

  a.children.add(p);
  a.children.add(img);

  li.children.add(a);

  return li;
}
