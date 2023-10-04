import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    bool isFirstLaunch = (prefs.getBool('isFirstLaunch') ?? false);

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
              const FractionallySizedBox(
                widthFactor: 0.8,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
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
