import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class LocationSettingScreen extends StatefulWidget {
  static String id = "location_setting_screen";
  @override
  _LocationSettingScreenState createState() => _LocationSettingScreenState();
}

class _LocationSettingScreenState extends State<LocationSettingScreen> {
  Completer<NaverMapController> _controller = Completer();
  Marker? _marker;
  List<Marker> _markers = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'icon/marker.png',
      ).then((image) {
        _marker = Marker(
          markerId: 'id',
          position: LatLng(37.563600, 126.962370),
          captionText: "커스텀 아이콘",
          captionColor: Colors.indigo,
          captionTextSize: 20.0,
          alpha: 0.8,
          captionOffset: 30,
          icon: image,
          anchor: AnchorPoint(0.5, 1),
          width: 45,
          height: 45,
          infoWindow: '인포 윈도우',
          // onMarkerTab: _onMarkerTap
        );
        _markers.add(_marker!);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          //_controlPanel(),
          _naverMap(),
        ],
      ),
    );
  }

  _naverMap() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          NaverMap(
            onMapCreated: _onMapCreated,
            onMapTap: _onMapTap,
            markers: _markers,
            initLocationTrackingMode: LocationTrackingMode.Follow,
            locationButtonEnable: true,
          ),
        ],
      ),
    );
  }

  // ================== method ==========================

  void _onMapCreated(NaverMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTap(LatLng latLng) {
    final newMarker = Marker(
      markerId: DateTime.now().toIso8601String(),
      position: latLng,
      infoWindow: '테스트',
      //onMarkerTab: _onMarkerTap,
    );

    _markers.removeAt(0);
    _markers.add(newMarker);

    setState(() {});
  }
}
