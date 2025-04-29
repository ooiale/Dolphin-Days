import 'package:dolphin_days/views/pages/aquarium/aquarium_page.dart';
import 'package:flutter/material.dart';
import 'package:dolphin_days/views/widgets/navigation/main_page_navbar.dart';
import 'package:flutter/services.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Aquarium fills the entire screen
          Positioned.fill(child: AquariumPage()),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/images/TitleLogo.png', height: 250),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(height: 120, child: MainPageNavbar()),
          ),
        ],
      ),
    );
  }
}
