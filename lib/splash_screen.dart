import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:smart_lab/page_utama.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterSplashScreen.scale(
//         useImmersiveMode: true,
//         childWidget: SizedBox(
//           height: 50,
//           child: Image.asset(''),
//         ),
//         gradient: const LinearGradient(
//           colors: [Colors.lightBlue, Colors.blue],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         duration: const Duration(milliseconds: 1500),
//         animationDuration: const Duration(milliseconds: 1000),
//         onAnimationEnd: () => debugPrint("On Scale End"),
//         nextScreen: const PageUtama(),
//       ),
//     );
//   }
// }

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen.scale(
        useImmersiveMode: true,
        childWidget: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
        gradient: const LinearGradient(
          colors: [Colors.lightBlue, Colors.blue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        duration: const Duration(milliseconds: 2000),
        animationDuration: const Duration(milliseconds: 1500),
        onAnimationEnd: () => debugPrint("On Scale End"),
        nextScreen: const PageUtama(),
      ),
    );
  }
}
