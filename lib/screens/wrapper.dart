import 'package:tutorApp/screens/FirstScreens/checkUser.dart';
import 'package:tutorApp/models/user.dart';
import 'package:tutorApp/screens/Authentication/onboardingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either Home or Authenticate widget
    if (user == null) {
      print("onboarding");
      return OnboardingPage();
    } else {
      print("splash");
      return Splash(
        uid: user.uid,
      );
    }
  }
}
