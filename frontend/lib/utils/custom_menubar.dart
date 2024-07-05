import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomMenuBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2), // Shadow position (only top)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildMenuItem(0, 'assets/icons/home-1.png', 'assets/icons/home-2.png'),
          _buildMenuItem(1, 'assets/icons/history-1.png', 'assets/icons/history-2.png'),
          _buildMenuItem(2, 'assets/icons/chat-1.png', 'assets/icons/chat-2.png'),
          _buildMenuItem(3, 'assets/icons/more-1.png', 'assets/icons/more-2.png'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index, String iconUnselected, String iconSelected) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            currentIndex == index ? iconSelected : iconUnselected,
            width: 30,
            height: 30,
          ),
        ],
      ),
    );
  }
}
