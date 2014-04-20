import 'dart:html';
import 'dart:convert';
import 'dart:js';
import 'dart:math';

List<Map> items;

void main() {

  // import에서 <template>를 복제합니다.
  /*var link = querySelector('link[rel="import"]');  
  var template = link.import.querySelector('#navbar');
  var clone = document.importNode(template.content, true);
  (clone.querySelector('#index') as Element).classes.add('active');
  querySelector('#menu').append(clone);*/

  // var url = 'https://www.googleapis.com/youtube/v3/videos?id=' + '7lCDEYXw3mM' + '&key=' + 'AIzaSyBpaXmomBFMaEB1nYhNrqZEiyPlBL10PYk' + '&part=snippet,contentDetails,statistics,status';

  // Parsing Parameter
  var params = new Map<String, String>();
  String qs = window.location.search.replaceFirst('?', '');
  print("parameters: " + qs);
  qs.split('&').forEach((e) {

    if (!e.contains('=')) {
      return;
    }

    List<String> kv = e.split('=');
    String v = kv[1].replaceAll('+', '%20');
    params[kv[0]] = Uri.decodeFull(v);
  });

  HttpRequest.getString('videos.json').then((content) {

    // Load Data
    items = JSON.decode(content);

    print("Load Data Complete...");

    // Add Document
    items.forEach((e) {
      context['index'].callMethod('add', [new JsObject.jsify({
          "id": e['id'],
          "title": e['title'],
          "category": e['category']
        })]);
    });

    print("Added Document for Search Engine...");

    // Count Tags
    Map<String, int> tags = new Map<String, int>();
    items.forEach((e) {
      e['category'].split(',').forEach((f) {
        String t = f.trim();
        tags.putIfAbsent(t, () => 0);
        tags[t]++;
      });
    });

    print("Counted Tags...");

    /*tags.forEach((k, v) {
      print(k + ", " + v.toString());
    });*/

    // Tag Cloud
    var r = new Random();
    context['cloud'].callMethod('words', [new JsObject.jsify(tags.keys.map((k) {
        return {
          "text": k,
          "size": 20 + (tags[k] / items.length) * 80
        };
      }))]);
    context['cloud'].callMethod('start');
    
    print("Display Tag Cloud...");

    // Display Videos
    if (params['q'] != null) {
      search(params['q']);
    } else {

      var ul = new UListElement();

      items.shuffle();
      items.getRange(0, 32).forEach((e) {
        ul.children.add(createListItem(e));
      });

      querySelector('.content').append(ul);
    }
    
    print("Display Videos...");
  });
}

Map getItem(String id) {
  return items.firstWhere((E) => E['id'] == id);
}

void search(String keyword) {

  querySelector('.content').children.clear();

  var ul = new UListElement();

  JsArray result = context['index'].callMethod('search', [keyword]);

  result.toList().forEach((e) {
    // http://stackoverflow.com/questions/19691693/how-to-convert-javascript-object-to-dart-map
    Map map = JSON.decode(context['JSON'].callMethod('stringify', [e]));

    ul.children.add(createListItem(getItem(map['ref'])));
  });

  querySelector('.content').append(ul);
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
