import 'dart:html';
import 'dart:convert';
import 'package:google_maps/google_maps.dart';

void main() {

  var mapOptions = new MapOptions()
      ..zoom = 8
      ..center = new LatLng(36.2011889, 127.8952727)
      ..mapTypeId = MapTypeId.ROADMAP;

  final map = new GMap(querySelector("#map-canvas"), mapOptions);

  HttpRequest.getString('places.json').then((content) {

    // Load Data
    List<Map> items = JSON.decode(content);

    items.forEach((e) {

      // Category Icon
      var icon;
      switch (e['category']) {
        case 'Academy':
          icon = 'res/university.png';
          break;
        case 'Bar':
          icon = 'res/bar_coktail.png';
          break;
        case 'Entertainment':
          icon = 'res/magicshow.png';
          break;
        case 'Shop':
          icon = 'res/supermarket.png';
          break;
        default:
          break;
      }

      e['items'].forEach((f) {
        print(f);

        var myLatLng;
        if ((f['lat'] != null) && (f['lng'] != null)) {
          
          addMarker(map, new LatLng(f['lat'], f['lng']), f['title'], icon);
          
        } else {
          
          // Geocoding
          final geocoder = new Geocoder();
          var req = new GeocoderRequest()..address = f['address'];
          
          print("Using Geocoding..." + f['address']);
          geocoder.geocode(req, (results, status) {

            // ERROR
            if (status != GeocoderStatus.OK) {
              print('Geocode was not successful for the following reason: ' + status.toString());
              return;
            }            
            
            addMarker(map, results.first.geometry.location, f['title'], icon);
          });
        }
      });
    });
  });
}

void addMarker(map, location, title, icon, {tel, web}) {
  // Marker
  Marker myMarker = new Marker()
  ..map = map
      ..position = location
      ..title = title;

  if (icon != null) {
    myMarker.icon = icon;
  }

  // Content
  var sb = new StringBuffer('<div><ul>')
      ..write('<li>')
      ..write(title)
      ..write('</li>');

  if (tel != null) {
    sb
        ..write('<li>')
        ..write(tel)
        ..write('</li>');
  }

  if (web != null) {
    sb
        ..write('<li>')
        ..write(web)
        ..write('</li>');
  }

  sb.write('</ul></div>');

  // Info Window
  var iwOptions = new InfoWindowOptions()..content = sb.toString();
  var infoWindow = new InfoWindow(iwOptions);

  myMarker.onClick.listen((MouseEvent) {
    infoWindow.open(map, myMarker);
  });
}
