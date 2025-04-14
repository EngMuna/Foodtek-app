import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodtek/app_constants.dart';
import 'package:foodtek/view/widgets/custom_button_widget.dart';
import 'package:foodtek/view/widgets/input_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:foodtek/controller/location_controller.dart';
import 'package:geocoding/geocoding.dart';

import 'cart_screens/check_out_screen.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  Set<Marker> markers = {};
  String _areaName = "Unknown Area";
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  void _loadSavedLocation() {
    final savedLocation =
        Provider.of<LocationController>(
          context,
          listen: false,
        ).selectedLocation;

    if (savedLocation != null) {
      setState(() {
        _selectedLocation = savedLocation;
        markers.add(
          Marker(
            markerId: MarkerId('saved_location'),
            position: savedLocation,
            infoWindow: InfoWindow(title: "Selected Location"),
          ),
        );
      });

      _fetchAreaName(savedLocation.latitude, savedLocation.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Provider.of<LocationController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "New Address",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            children: [
              SizedBox(
                height: 200.h,
                width: double.infinity,
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(31.985934703432616, 35.900362288558114),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    final savedLocation =
                        Provider.of<LocationController>(
                          context,
                          listen: false,
                        ).selectedLocation;
                    if (savedLocation != null) {}
                  },
                  onCameraIdle: () {
                    _fetchAreaNameFromMap();
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                height: 80.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.black12),
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: Icon(Icons.location_pin, color: Colors.grey),
                  title: Text("Area"),
                  subtitle: Text(_areaName),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Change",
                      style: GoogleFonts.inter(
                        color: AppConstants.buttonColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              InputWidget(
                textEditingController: locationController.buildingController,
                obscureText: false,
                backgroundColor: Colors.white,
                borderColor: Colors.black12,
                hintText: "Building name",
                label: "Building name",
                width: double.infinity,
              ),
              SizedBox(height: 20.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InputWidget(
                      textEditingController:
                          locationController.apartmentNumController,
                      obscureText: false,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black12,
                      hintText: "Apt. number",
                      label: "Apt. number",
                      width: 180.w,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(width: 20.w),
                    InputWidget(
                      textEditingController: locationController.floorController,
                      obscureText: false,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black12,
                      hintText: "Floor",
                      label: "Floor",
                      width: 180.w,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              InputWidget(
                textEditingController: locationController.streetController,
                obscureText: false,
                backgroundColor: Colors.white,
                borderColor: Colors.black12,
                hintText: "Street",
                label: "Street",
                width: double.infinity,
              ),
              SizedBox(height: 20.h),
              InputWidget(
                textEditingController: locationController.additionalController,
                obscureText: false,
                backgroundColor: Colors.white,
                borderColor: Colors.black12,
                hintText: "Additional directions (optional)",
                label: "Additional directions (optional)",
                width: double.infinity,
              ),
              SizedBox(height: 20.h),
              CustomButtonWidget(
                title: "Save Address",
                colors: [AppConstants.buttonColor, AppConstants.buttonColor],
                titleColor: Colors.white,
                width: double.infinity,
                borderRadius: 12.r,
                height: 60.h,
                onPressed: () {
                  if (locationController.buildingController.text.isEmpty ||
                      locationController.apartmentNumController.text.isEmpty ||
                      locationController.floorController.text.isEmpty ||
                      locationController.streetController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: Text(
                            textAlign: TextAlign.center,
                            "Please fill in all the fields",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          actions: [
                            CustomButtonWidget(
                              title: "Ok",
                              colors: [
                                AppConstants.buttonColor,
                                AppConstants.buttonColor,
                              ],
                              height: 60.h,
                              borderRadius: 12.r,
                              titleColor: Colors.white,
                              width: 300.w,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CheckOutScreen()),
                    );
                    locationController.addAddress(
                      areaName: _areaName,
                      buildingName: locationController.buildingController.text,
                      apartmentNumber:
                          locationController.apartmentNumController.text,
                      floor: locationController.floorController.text,
                      street: locationController.streetController.text,
                      additionalDirections:
                          locationController.additionalController.text,
                      location: _selectedLocation ?? LatLng(0, 0),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchAreaName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          _areaName =
              "${placemark.locality ?? ''}, ${placemark.administrativeArea ?? ''}";
        });
      } else {
        setState(() {
          _areaName = "Unknown Area";
        });
      }
    } catch (e) {
      setState(() {
        _areaName = "Error fetching area";
      });
    }
  }

  void _fetchAreaNameFromMap() {
    final visibleRegionCenter =
        _selectedLocation ?? LatLng(31.985934703432616, 35.900362288558114);
    _fetchAreaName(visibleRegionCenter.latitude, visibleRegionCenter.longitude);
  }
}
