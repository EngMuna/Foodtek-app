import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodtek/app_constants.dart';
import 'package:foodtek/controller/location_controller.dart';
import 'package:foodtek/view/screens/registration_screens/login_screen.dart';
import 'package:foodtek/view/widgets/onboarding_widgets/slides_widget.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button_widget.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Provider.of<LocationController>(context);

    return Scaffold(
      body: SlideWidget(
        backgroundImage: AssetImage("assets/images/maps.png"),
        imagePath: "assets/images/slide2.png",
        title: "Turn On Your Location",
        description:
            "To Continue, Let Your Device Turn On Location, Which Uses Google’s Location Service.",
        widget: Column(
          children: [
            CustomButtonWidget(
              title: "Yes, Turn It On",
              onPressed: () async {
                print("Button pressed");
                await locationController.requestLocationPermission(context);
              },


            ),

            SizedBox(height: 8.h),
            CustomButtonWidget(
              title: "Cancel",
              titleColor: AppConstants.primaryTextColor,
              colors: [Color(0xFFC2C2C2), Color(0xFFC2C2C2)],
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

