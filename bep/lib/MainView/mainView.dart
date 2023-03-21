import 'package:bep/Api/quizeController.dart';
import 'package:bep/Api/mapController.dart';
import 'package:bep/MainView/TopNavbar/topNavbar.dart';
import 'package:bep/MainView/globalButton.dart';
import 'package:bep/MainView/quizeCardContainer.dart';
import 'package:bep/ModalView/logic/addMarker.dart';
import 'package:bep/ModalView/logic/handleSelectedQuize.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

class mainView extends StatefulWidget {
  final GoogleSignInAccount googleUser;
  const mainView({super.key, required this.googleUser});

  @override
  _mainViewState createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  static final LatLng _kMapCenter = LatLng(37.485172, 126.783173);
  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 10.0, tilt: 0, bearing: 0);

  late GoogleMapController _controller;

  Map<MarkerId, Marker> _markers = {};
  QuizeController quizeController = QuizeController();
  MapController mapController = MapController();
  List<Quize> quizes = [];
  bool _isQuizeOpen = false;
  // double _answerLatitude = 0.0;
  // double _answerLongitude = 0.0;

  initState() {
    super.initState();
    _getQuize();
  }

  Future<void> _getQuize() async {
    final response = await quizeController.getQuize();
    print(response);
    setState(() {
      quizes = response!;
    });
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller.setMapStyle(value);
  }

  Future<void> _onCardSelected(Quize quize, LatLng latLng) async {
    print(quize.latitude);
    handleSelectedQuize(
        quize, double.parse(quize.latitude), double.parse(quize.longitude));
    mapController.onMapTap(context);
    setState(() {
      addMarker(_markers, latLng);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kInitialPosition,
            onMapCreated: onMapCreated,
            myLocationButtonEnabled: false,
            markers: _markers.values.toSet(),
            onTap: (latLng) {
              _onCardSelected(quizes[0], latLng);
            },
          ),
          SafeArea(
            child: Stack(
              children: [
                topNavbar(name: widget.googleUser.displayName.toString()[0]),
                globalButton(
                  isQuizeOpen: _isQuizeOpen,
                  onToggleActive: (value) {
                    setState(() {
                      _isQuizeOpen = value;
                    });
                  },
                ),
                quizeCardContainer(
                  isQuizeOpen: _isQuizeOpen,
                  quizes: quizes,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
