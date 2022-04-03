import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:freelance_chef_app/custom/season_appbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorldMap extends StatelessWidget {
  const WorldMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<BitmapDescriptor>(
          future: BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(96, 96)),
              "assets/images/chef_marker.png"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MapSample(myIcon: snapshot.data!);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {

  BitmapDescriptor myIcon;

  MapSample({Key? key, required this.myIcon}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState(myIcon);
}

class MapSampleState extends State<MapSample> {

  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor myIcon;
  String? mapStyle;
  ByteData? userImageData;

  MapSampleState(this.myIcon);

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(43.118747, 131.883221),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(43.118747, 131.883221),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    DefaultAssetBundle.of(context).loadString('assets/google_map_style.json').then((string) {
      mapStyle = string;
    }).catchError((error) {
      print(error.toString());
    });

    DefaultAssetBundle.of(context)
        .load('assets/images/user_marker.png')
        .then((data) => setState(() => userImageData = data));
    super.initState();
  }
  // @override
  // void initState() async {
  //   await BitmapDescriptor.fromAssetImage(
  //           ImageConfiguration(size: Size(48, 48)),
  //           "assets/images/chef_marker.png")
  //       .then((value) {
  //     myIcon = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeasonAppBar(
        titleWidget: const Text("WorldMap"),
      ).build(context),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        // mapType: MapType.normal,
        markers: {
          Marker(
            markerId: MarkerId("s"),
            zIndex: 3.0,
            position: LatLng(43.115766, 131.878280),
            infoWindow: InfoWindow(title: "Fries"),
            icon: myIcon,
          ),
          Marker(
            markerId: MarkerId("s"),
            zIndex: 3.0,
            position: LatLng(43.115819, 131.879475),
            infoWindow: InfoWindow(title: "Fries"),
            icon: myIcon,
          ),
          Marker(
            markerId: MarkerId("s"),
            zIndex: 3.0,
            position: LatLng(43.115147, 131.879313),
            infoWindow: InfoWindow(title: "Fries"),
            icon: myIcon,
          ),
          Marker(
            markerId: MarkerId("s"),
            zIndex: 3.0,
            position: LatLng(43.114654, 131.879915),
            infoWindow: InfoWindow(title: "Fries"),
            icon: myIcon,
          ),

          // Marker(
          //   markerId: MarkerId("s"),
          //   zIndex: 3.0,
          //   position: LatLng(43.114937, 131.878684),
          //   infoWindow: InfoWindow(title: "Me"),
          //   icon: BitmapDescriptor.fromBytes(userImageData!.buffer.asUint8List()),
          // )

        },
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) async {
          controller.setMapStyle(mapStyle);
          _controller.complete(controller);
        },
      ),
    );
  }
}
