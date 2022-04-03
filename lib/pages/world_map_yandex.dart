import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freelance_chef_app/custom/season_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class WorldMapYandex extends StatelessWidget {
  const WorldMapYandex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WorldMapYandexSample(),
      ),
    );
  }
}

class WorldMapYandexSample extends StatefulWidget {


  WorldMapYandexSample({Key? key}) : super(key: key);

  @override
  State<WorldMapYandexSample> createState() =>
      WorldMapYandexSampleState();
}

class WorldMapYandexSampleState extends State<WorldMapYandexSample> {

  String? mapStyle;
  ByteData? imageData;
  ByteData? userImageData;

  WorldMapYandexSampleState();

  @override
  void initState() {
    DefaultAssetBundle.of(context)
        .loadString('assets/yandex_map_style.json')
        .then((string) {
      mapStyle = string;
    }).catchError((error) {
      print(error.toString());
    });
    DefaultAssetBundle.of(context)
        .load('assets/images/chef_marker.png')
        .then((data) => setState(() => imageData = data));
    DefaultAssetBundle.of(context)
        .load('assets/images/user_marker.png')
        .then((data) => setState(() => userImageData = data));
    super.initState();
  }

  Future<bool> get locationPermissionNotGranted async =>
      !(await Permission.location.request().isGranted);

  void _showMessage(BuildContext context, Text text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SeasonAppBar(
        titleWidget: const Text("WorldMapYandex"),
      ).build(context),
      body: YandexMap(
        onMapCreated: (controller) async {
          // controller.toggleNightMode(enabled: true);
          if (await locationPermissionNotGranted) {
            _showMessage(
                context, const Text('Location permission was NOT granted'));
            return;
          } else {
            await controller.showUserLayer(
                iconName: 'assets/images/user_marker.png',
                arrowName: 'assets/images/user_marker.png',
                accuracyCircleFillColor: Colors.black.withOpacity(.5),
                userArrowOrientation: false);
            controller.logoAlignment(
                horizontal: HorizontalAlignment.left,
                vertical: VerticalAlignment.bottom);
            controller.toggleMapRotation(enabled: false);
          }

          controller.setMapStyle(style: mapStyle!);
          // 43.114654, 131.879915
          controller.move(
              point: Point(latitude: 43.118747, longitude: 131.883221));

          controller.addPlacemark(Placemark(
              point: Point(latitude: 43.115766, longitude: 131.878280),
              style: PlacemarkStyle(
                  opacity: 1, rawImageData: imageData!.buffer.asUint8List())));
          controller.addPlacemark(Placemark(
              point: Point(latitude: 43.115819, longitude: 131.879475),
              style: PlacemarkStyle(
                  opacity: 1, rawImageData: imageData!.buffer.asUint8List())));
          controller.addPlacemark(Placemark(
              point: Point(latitude: 43.114937, longitude: 131.878684),
              style: PlacemarkStyle(
                  opacity: 1, rawImageData: imageData!.buffer.asUint8List())));
          controller.addPlacemark(Placemark(
              point: Point(latitude: 43.114654, longitude: 131.879915),
              style: PlacemarkStyle(
                  opacity: 1, rawImageData: imageData!.buffer.asUint8List())));

          // controller.addPlacemark(Placemark(
          //     point: Point(latitude: 43.115147, longitude: 131.879313),
          //     style: PlacemarkStyle(
          //         opacity: 1, rawImageData: userImageData!.buffer.asUint8List())));
        },
      ),
    );
  }
}
