import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m335_sinan_menolfi/db.dart';
import 'package:m335_sinan_menolfi/home.dart';

class InitLoad extends StatefulWidget {
  @override
  _InitLoadState createState() => _InitLoadState();
}

class _InitLoadState extends State<InitLoad> {
  @override
  void initState() {
    super.initState();
    checkFirstSeen(context);
  }

  Future<void> checkFirstSeen(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = (prefs.getBool('isFirstLaunch') ?? true);

    if (isFirstLaunch) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } else {
      await prefs.setBool('isFirstLaunch', false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => initscreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class initscreen extends StatefulWidget {
  @override
  _initscreen createState() => _initscreen();
}

class _initscreen extends State<initscreen> {
  final userNameInput = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userNameInput.dispose();
  }

  Future<String> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });

    final Position position = await Geolocator.getCurrentPosition();
    final LatLng userLatLng = LatLng(position.latitude, position.longitude);
    return userLatLng.toString();
  }

  void writeToDB(String UserName) async {
    String location = await getUserCurrentLocation();

    DBConnection dbConnection = DBConnection();
    dbConnection.insertUser(UserName, location);
  }

  void saveUsernmeLocaly(String UserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserName', UserName);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create an Account:",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              const SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: userNameInput,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter E-Mail',
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Text(""),
              SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    saveUsernmeLocaly(userNameInput.text.toString());
                    writeToDB(userNameInput.text);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
