import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text(
          'SnapStyle merupakan aplikasi yang memberikan Anda sebuah berita terkini terkait fashion yang sedang trend',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
