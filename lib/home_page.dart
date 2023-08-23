import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multimedia Tools'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Gambar',
                style: TextStyle(color: Color(0xFF737373)),
              ),
            ),
            ListTile(
              title: Text('  Kompresi Gambar'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushNamed(context, '/kompresi_gambar');
              },
            ),
            ListTile(
              title: Text(
                'Audio',
                style: TextStyle(color: Color(0xFF737373)),
              ),
            ),
            ListTile(
              title: Text('  Kompresi Audio'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushNamed(context, '/kompresi_audio');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Selamat Datang',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
