import 'package:flutter/material.dart';
import '../LoginScreen/NewLogin_Screen.dart';
import '../Utils/ColorConstant.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _introData = [
    {
      "title": "Mind Care.\nAnywhere.",
      "description": "Consult psychiatrists from \nthe comfort of your home",
      "image": "assets/Images/intro.png"
    },
    {
      "title": "Trusted\nPrescriptions.",
      "description": "Secure digital prescriptions \nat your fingertips",
      "image": "assets/Images/intro2.png"
    },
    {
      "title": "Medicines\nto Your Doorstep.",
      "description": "Get your prescribed meds \ndelivered quickly and privately",
      "image": "assets/Images/intro3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _introData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // --- Title at Top ---
                        Text(
                          _introData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.colorIntroBG, // app theme color
                          ),
                        ),

                        const SizedBox(height: 30),

                        // --- Image in Middle ---
                        Image.asset(
                          _introData[index]["image"]!,
                          height: 220,
                        ),

                        const SizedBox(height: 30),

                        // --- Description below Image ---
                        Text(
                          _introData[index]["description"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: ColorConstant.colorBlack,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- Dots Indicator ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _introData.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? ColorConstant.colorIntroBG
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.colorIntroBG,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_currentPage == _introData.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreenNew()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Text(
                  _currentPage == _introData.length - 1
                      ? "Get Started"
                      : "Next",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
