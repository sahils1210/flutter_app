import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

void main() {
  MapView.setApiKey("AIzaSyB890Ue4saAFSX4HPwd4_hZWt9-lL6wCGc");
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MapPage(),
  ));
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => new _MapPageState();
}

const String api_key = "AIzaSyB890Ue4saAFSX4HPwd4_hZWt9-lL6wCGc";

class _MapPageState extends State<MapPage> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(api_key);
  Uri staticMapUri;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    showMap();
    cameraPosition =
        new CameraPosition(new Location(19.1167045, 72.8574105), 2.0);
    staticMapUri = staticMapProvider.getStaticUri(
        new Location(19.1167045, 72.8574105), 12,
        height: 400, width: 900, mapType: StaticMapViewType.roadmap);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
      ),
      body: new Column(
          /*  mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 300.0,
            child: new Stack(
              children: <Widget>[
                new Center(
                  child: Container(
                    child: new Text(
                      "Map should be here",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                new InkWell(
                  child: new Center(
                    child: new Image.network(staticMapUri.toString()),

                  ),
                  onTap: showMap,
                ),
              ],
            ),
          ),

          new Container(
            padding: new EdgeInsets.only(top: 10.0),
            child: new Text(
              "Tap the map to interact",
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          new Container(
            padding: new EdgeInsets.only(top: 25.0),
            child: new Text(
                "Camera Position: \n\nLat: ${cameraPosition.center.latitude}\n\nLng:${cameraPosition.center.longitude}\n\nZoom: ${cameraPosition.zoom}"),
          ),
        ],*/
          ),
    );
  }

  List<Marker> markers = <Marker>[
    new Marker("1", "BSR Restuarant", 28.421364, 77.333804,
        color: Colors.amber),
    new Marker("2", "Flutter Institute", 28.418684, 77.340417,
        color: Colors.purple),
  ];

  showMap() {
    MapView.setApiKey("AIzaSyB890Ue4saAFSX4HPwd4_hZWt9-lL6wCGc");
    mapView.show(new MapOptions(
        mapViewType: MapViewType.normal,
        initialCameraPosition:
            new CameraPosition(new Location(19.116954, 72.856557), 15.0),
        showUserLocation: true, //To get current location on tap
        title: "Recent Location"));
    mapView.setMarkers(markers);
    mapView.zoomToFit(padding: 100);

    mapView.onMapTapped.listen((_) {
      setState(() {
        mapView.setMarkers(markers);
        mapView.zoomToFit(padding: 100);
      });
    });
  }
}
