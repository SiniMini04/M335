import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GoogleMapController mapController;
  late Future<LatLng> userLocation;

  Future<LatLng> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });

    final Position position = await Geolocator.getCurrentPosition();
    final LatLng userLatLng = LatLng(position.latitude, position.longitude);
    return userLatLng;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getFriendEmail(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Add a Friend'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Enter the E-Mail of a Friend to share Location'),
                  Text(''),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter E-Mail',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Align buttons to the start and end
                children: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ]);
      },
    );
  }

  void initState() {
    super.initState();
    userLocation = getUserCurrentLocation();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            FutureBuilder<LatLng>(
              future: userLocation,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data!,
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Positioned(
              bottom: 60.0,
              left: 12.0,
              child: Stack(children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 50,
                  ),
                  onPressed: () {
                    print("object");
                    getFriendEmail(context);
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
