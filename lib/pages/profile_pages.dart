import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  Future<Map<String, String>> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'N/A';
    final password = prefs.getString('password') ?? 'N/A';
    return {'username': username, 'password': password};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${userData['username']}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Password: ${userData['password']}', style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          }
        }
      },
    );
  }
}
