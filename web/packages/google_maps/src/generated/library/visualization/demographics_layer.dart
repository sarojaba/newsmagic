// Copyright (c) 2013, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of google_maps_visualization;

class DemographicsLayer extends jsw.TypedJsObject {
  static DemographicsLayer $wrap(js.JsObject jsObject) => jsObject == null ? null : new DemographicsLayer.fromJsObject(jsObject);
  DemographicsLayer.fromJsObject(js.JsObject jsObject)
      : super.fromJsObject(jsObject);
  DemographicsLayer([DemographicsLayerOptions opts])
      : super(maps['visualization']['DemographicsLayer'], [jsw.Serializable.$unwrap(opts)]);

  GMap get map => GMap.$wrap($unsafe.callMethod('getMap'));
  DemographicsQuery get query => DemographicsQuery.$wrap($unsafe.callMethod('getQuery'));
  List<DemographicsStyle> get styles => jsw.TypedJsArray.$wrapSerializables($unsafe.callMethod('getStyles'), DemographicsStyle.$wrap);
  set map(GMap map) => $unsafe.callMethod('setMap', [map == null ? null : map.$unsafe]);
  set options(DemographicsLayerOptions options) => $unsafe.callMethod('setOptions', [options == null ? null : options.$unsafe]);
  set query(DemographicsQuery query) => $unsafe.callMethod('setQuery', [query == null ? null : query.$unsafe]);
  set style(List style) => $unsafe.callMethod('setStyle', [jsw.jsify(style)]);
}
