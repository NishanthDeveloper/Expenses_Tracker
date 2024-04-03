import 'package:coin_compass/screens/Splash_Screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/Splash_Screen/splash_screen_2.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Coin Compass",
        theme: ThemeData(
            colorScheme: ColorScheme.light(
                background: Colors.grey.shade100,
                onBackground: Colors.black,
                primary: const Color(0xff00B2E7),
                secondary: const Color(0xffE064f7),
                tertiary: const Color(0xffff8D6C),
                outline: Colors.grey)),
        //Check the user has authentication credentials
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot<User?> user) {
              if (user.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                );
              } else if (user.hasData) {
                return Splashscreen();
                //return const SellScreen();
              } else {
                return Splashscreen2();
              }
            }));
  }
}
