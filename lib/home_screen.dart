import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_flutter/controller/firestore.dart';
import 'package:login_flutter/login_screen.dart';
import 'package:login_flutter/profil_screen.dart';
import 'package:login_flutter/history.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

class Homescreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();

  final GoogleSignInAccount credential;
  Homescreen(
    this.credential, {
    super.key,
  });
}

class HomeScreenState extends State<Homescreen> {
  CameraController? _camera;
  Future<void>? _initializeCameraFuture;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _camera = CameraController(
      camera,
      ResolutionPreset.high,
    );
    await _camera!.initialize();
  }

  @override
  void dispose() {
    _camera!.dispose();
    super.dispose();
  }

  String? _currentAddress;
  Position? _currentPosition;

  final startCoordinate = new Location(-6.995286458236605, 110.45362602636555);
  bool isLoadingin = false;
  bool isLoadingout = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Hi, ${widget.credential.displayName} "),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              var googlesignin = GoogleSignIn();
              var credential = await googlesignin.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: Image.asset(
                    'assets/images/logoabs.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Card(
                //   margin:
                //       EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                //   elevation: 5,
                //   color: Colors.black,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //             builder: (context) =>
                //                 Profilescreen(credential: widget.credential)),
                //       );
                //     },
                //     splashColor: Colors.white,
                //     child: Container(
                //       height: 50,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(15),
                //         gradient: LinearGradient(
                //           colors: [Colors.deepPurpleAccent, Colors.deepPurple],
                //           begin: Alignment.topLeft,
                //           end: Alignment.bottomRight,
                //         ),
                //       ),
                //       child: Center(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Icon(Icons.person, color: Colors.white),
                //             SizedBox(width: 10),
                //             Text(
                //               "Profile",
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  elevation: 5,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              Profilescreen(credential: widget.credential),
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    },
                    splashColor: Colors.white,
                    child: !isLoading
                        ? Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurpleAccent,
                                  Colors.deepPurple
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  elevation: 5,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isLoadingin = true;
                      });
                      _getCurrentPosition(context, "Masuk");
                    },
                    splashColor: Colors.white,
                    child: !isLoadingin
                        ? Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurpleAccent,
                                  Colors.deepPurple
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.input, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Attendance In",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  elevation: 5,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isLoadingout = true;
                      });
                      _getCurrentPosition(context, "Keluar");
                    },
                    splashColor: Colors.white,
                    child: !isLoadingout
                        ? Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurpleAccent,
                                  Colors.deepPurple
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.exit_to_app, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "Attendance Out",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  elevation: 5,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => History()),
                      );
                    },
                    splashColor: Colors.white,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "History",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> showCamera(String tipe) async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );

    var filepath = pickedFile?.path;
    var filename = filepath?.split('/').last;

    var fileUin8 = File(filepath!).readAsBytesSync();
    var blob = base64.encode(fileUin8);

    await FirestoreHelper.createAbsensi(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        widget.credential.email,
        widget.credential.displayName,
        tipe,
        blob);
    _initializeCameraFuture;
  }

  Future<void> _getCurrentPosition(BuildContext context, String tipe) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() => _currentPosition = position);

      final endCoordinate =
          new Location(_currentPosition!.latitude, _currentPosition!.longitude);
      final distanceInMeter = HaversineDistance()
          .haversine(startCoordinate, endCoordinate, Unit.METER);

      if (distanceInMeter > 5) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Jarak Anda terlalu jauh $distanceInMeter m, ayo mendekat lagi"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
        setState(() {
          isLoadingin = false;
          isLoadingout = false;
        });
      } else {
        await showCamera(tipe);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Absensi berhasil dilakukan"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        setState(() {
          isLoadingin = false;
          isLoadingout = false;
        });
      }
    }).catchError((e) {
      debugPrint(e.toString());

      setState(() {
        isLoadingin = false;
        isLoadingout = false;
      });
    });
  }
}
