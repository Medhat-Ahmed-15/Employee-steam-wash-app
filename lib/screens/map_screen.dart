import 'dart:async';
import 'dart:io';
import 'package:employee_steam_wash_app/Assistants/general_methods.dart';
import 'package:employee_steam_wash_app/Providers/address_data_provider.dart';
import 'package:employee_steam_wash_app/Socket_IO/stream_socket.dart';
import 'package:employee_steam_wash_app/global_variables.dart';
import 'package:employee_steam_wash_app/key.dart';
import 'package:employee_steam_wash_app/screens/day_order_details_screen.dart';
import 'package:employee_steam_wash_app/screens/tabs_screen.dart';
import 'package:employee_steam_wash_app/widgets/confirmationDialog.dart';
import 'package:employee_steam_wash_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/MapScreen';

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    underMaintenanceEvent(context);
    doneMaintenanceEvent(context);

    //this request for enebling notifications is mainly for ios users since the default in ios is that it is disabled unlike android
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
//A createdStream transports ReceivedNotification objects when notifications are created. In other words, if you press the “View Orders” button a notification will be created and you can listen to the createdStream to get the ReceivedNotification object and do something with it. The ReceivedNotification object holds all kinds of information about your notification.
    AwesomeNotifications().createdStream.listen((notification) {
      print('Notification created ${notification.channelKey}');
    });

    AwesomeNotifications().actionStream.listen((notification) {
      //since when we open the notification or dismiss it on iOS, the badge number doesn’t go down. That is why we need to manually set up the logic to make sure this number doesn’t grow out of proportion.
      if (notification.channelKey == 'App_Is_Under_Maintenance_Channel' &&
          Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //Google an position variables
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  Position currentPosition;
  var geoLocator = Geolocator();
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  //bool variables
  bool drawerOpen = true;
  bool loading = false;
  bool _isInit = true;
  bool isInit = true;
  bool switchToConfirmButton = false;
  bool expandlateButton = false;

  //String variables
  String resultAfterConfirming;

  //Locating current location
  Future<void> locatePosition() async {
    //get current position

    setState(() {
      loading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    //get latitude and longitude from that position
    LatLng latlngPosition = LatLng(position.latitude, position.longitude);

    //locating camera towards this position
    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 14);

    //updating the camera position
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //converting latlng to readable addresses
    String address =
        await Provider.of<AddressDataProvider>(context, listen: false)
            .convertToReadableAddress(position);

    setState(() {
      loading = false;
    });
  }

  void displayRoute() async {
    if (_isInit == true) {
      if (resultAfterConfirming != null) {
        if (resultAfterConfirming ==
            'returnedToMapScreenAfterConfirmingOrder') {
          setState(() {
            switchToConfirmButton = true;
            drawerOpen = false;
          });
          await getPlaceDirection();

          // cancelRequestTimer = Timer(const Duration(seconds: 15), () {
          //   if (alreadyCancelled != true) {
          //     cancelRequest();
          //   }
          // });
        }
      }
    }
    _isInit = false;
  }

  resetApp() async {
    setState(() {
      polyLineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
      switchToConfirmButton = false;
      drawerOpen = true;
    });

    locatePosition();
  }

  Widget showButton(String text, Function handlePress) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FlatButton(
          child: Container(
            margin: EdgeInsets.only(bottom: 100, left: 50, right: 50),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 50,
            width: 400,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          onPressed: handlePress),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('employee id from map screen ' + currentEmployeeId);
    resultAfterConfirming = ModalRoute.of(context).settings.arguments as String;

    displayRoute();

    return Scaffold(
      drawer: MainDrawer(),
      key: scaffoldKey,
      body: Stack(
        children: [
          //Map*****************************************************************
          GoogleMap(
            padding: EdgeInsets.only(bottom: 200),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            markers: markersSet,
            circles: circlesSet,
            polylines: polyLineSet,
            initialCameraPosition: MapScreen._kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
          ),

          //Shaded Container****************************************************
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
            ),
          ),

          //View Orders Button or confirm button **************************************************
          switchToConfirmButton == false
              ? showButton(
                  'View orders',
                  () {
                    Navigator.pushNamed(context, TabsScreen.routName);
                  },
                )
              : showButton(
                  'Confirm arrival',
                  () async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) =>
                            ConfirmationDialog());
                    await Future.delayed(Duration(seconds: 5));

                    await GeneralMethods.setEmployeeStatus('arrived');

                    employeeArrivalEvent(pickedorder.id);

                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      TabsScreen.routName,
                    );
                    resetApp();
                  },
                ),

          //Current location text
          switchToConfirmButton == true
              ? const Text('')
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: loading == true
                      ? Container(
                          margin: const EdgeInsets.only(
                              bottom: 50, left: 50, right: 50),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            child: Text(
                              Provider.of<AddressDataProvider>(context)
                                          .currentLocation !=
                                      null
                                  ? Provider.of<AddressDataProvider>(context)
                                      .currentLocation
                                      .placeName
                                  : 'Current Location',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                ),

          //Hamburger Button
          Positioned(
            top: 70.0,
            left: 25.0,
            child: GestureDetector(
              onTap: () {
                if (!drawerOpen) {
                  setState(() {
                    expandlateButton = !expandlateButton;
                  });
                } else {
                  scaffoldKey.currentState.openDrawer();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: drawerOpen == true
                          ? const Icon(
                              Icons.menu,
                              color: Colors.black,
                            )
                          : Container(
                              width: 30,
                              height: 30,
                              child: Image.asset('assets/images/late.png'),
                            ),
                      radius: 20.0,
                    ),
                    if (expandlateButton == true && drawerOpen == false)
                      const Text(
                        'Confirm arriving late:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    if (expandlateButton == true && drawerOpen == false)
                      FlatButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          orderLateEvent(
                            pickedorder.id,
                          );

                          Fluttertoast.showToast(
                              msg:
                                  'We have notified the customer that you are going to arrive late 👍',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);

                          setState(() {
                            expandlateButton = !expandlateButton;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = Provider.of<AddressDataProvider>(context, listen: false)
        .currentLocation;

    var finalPos = Provider.of<AddressDataProvider>(context, listen: false)
        .destinationLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        PointLatLng(initialPos.latitude, initialPos.longitude),
        PointLatLng(finalPos.latitude, finalPos.longitude));

    pLineCoordinates.clear();

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            //So basically, we have done here that now we have a list of latitude and longitude which will allow us to draw a line on map.
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

//Now we have to create an instance of the fully line and we have to pass the required parameters to it in order to redraw the polyline.

    Polyline polyline = Polyline(
        color: Theme.of(context).primaryColor,
        polylineId: PolylineId('PolylineID'),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true);

//but before we add a new one we have to make it clear that polyline is empty when ever we add a polyline to polyline set that why I cleared the set and aslo the list
    polyLineSet.add(polyline);

//showayt tazbeetat for animating the camera when drawing the line
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpMArker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow:
            InfoWindow(title: initialPos.placeName, snippet: 'my Location'),
        position: pickUpLatLng,
        markerId: MarkerId('pickUpId'));

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: 'DropOff Location'),
        position: dropOffLatLng,
        markerId: MarkerId('dropOffId'));

    setState(() {
      markersSet.add(pickUpMArker);
      markersSet.add(dropOffLocMarker);
    });
  }
}
