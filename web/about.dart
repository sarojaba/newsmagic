import 'dart:html';

void main() {
  // import에서 <template>를 복제합니다.
  var link = querySelector('link[rel="import"]');  
  var template = link.import.querySelector('#navbar');
  var clone = document.importNode(template.content, true);
  (clone.querySelector('#about') as Element).classes.add('active');
  querySelector('#menu').append(clone);
}
