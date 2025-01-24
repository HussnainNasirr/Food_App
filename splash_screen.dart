import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  final Widget nextPage;

  const SplashScreen({Key? key, required this.nextPage}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Rotate for 3 seconds
    )..repeat(); // Repeat the animation indefinitely

    _rotation = Tween<double>(begin: 0.0, end: 2 * 3.14159) // Complete 360-degree rotation around the Y-axis
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Navigate to next screen after a delay
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => widget.nextPage),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.rotationY(_rotation.value), // Horizontal (Y-axis) rotation
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Image.asset(
            'assets/logo.jpg',
            height: 150,
          ),
        ),
      ),
    );
  }
}
