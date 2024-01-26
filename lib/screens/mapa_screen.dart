import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_scan/models/scan_model.dart';

// Pantalla que mostra un mapa amb la ubicació d'un escaneig
class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  late CameraPosition _puntInicial;
  bool isMapTypeNormal = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    _puntInicial = CameraPosition(
      target: scan.getLatLng(),
      zoom: 15,
    );

    Set<Marker> markers = Set<Marker>();
    markers.add(Marker(
      markerId: MarkerId('id1'),
      position: scan.getLatLng(),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        // Botó per tornar enrere
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // Botó per tornar a la posició inicial
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Tornar a la posició inicial (_puntInicial)
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(_puntInicial),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        // Alternar entre Mapa Normal i Híbrid
        mapType: isMapTypeNormal ? MapType.normal : MapType.hybrid,
        initialCameraPosition: _puntInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
        },
      ),
      // Botó flotant per canviar entre Mapa Normal i Híbrid
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isMapTypeNormal = !isMapTypeNormal;
          });
        },
        child: Icon(Icons.layers),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}