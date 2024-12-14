import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk bekerja dengan JSON
import 'package:http/http.dart' as http; // Untuk koneksi HTTP
import 'package:fashionapp_uas/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Untuk SharedPreferences
import 'package:fashionapp_uas/editprofilescreen.dart'; // Import screen untuk Edit Profile

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;
  String username = '';
  String email = '';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<List<dynamic>> _loadUserData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/users'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData; // Mengembalikan data user
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void login(String username, String password) async {
    try {
      final List<dynamic> users = await _loadUserData();
      bool foundUser = false;

      for (var user in users) {
        if (user['username'] == username && user['password'] == password) {
          setState(() {
            isLoggedIn = true;
            this.username = user['username'];
            email = user['email'];
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true); // Menyimpan status login
          await prefs.setString('username', user['username']);
          await prefs.setString('email', user['email']);
          foundUser = true;
          break;
        }
      }

      if (!foundUser) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password.')),
        );
      } else {
        // Navigasi ke halaman utama atau profil setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading user data.')),
      );
    }
  }

  void logout() async {
    setState(() {
      isLoggedIn = false;
      username = '';
      email = '';
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedEmail = prefs.getString('email');

    if (savedUsername != null && savedEmail != null) {
      setState(() {
        isLoggedIn = true;
        username = savedUsername;
        email = savedEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 236, 70, 70),
              Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoggedIn ? _buildProfileView() : _buildLoginView(),
      ),
    );
  }

  Widget _buildLoginView() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  login(usernameController.text, passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundImage: const AssetImage('assets/images/qiqi.png'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          username,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email,
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ListTile(
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    username: username,
                    email: email,
                  ),
                ),
              );
              if (updated == true) {
                _checkLoginStatus();
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: logout,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
