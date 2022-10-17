import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/screens/jobs_screen.dart';
import 'package:fiverr/screens/login_screen.dart';
import 'package:fiverr/screens/profile_screen.dart';
import 'package:fiverr/screens/search_screen.dart';
import 'package:fiverr/screens/upload_jobs.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// ignore: must_be_immutable
class BottomNavigationBarForApp extends StatelessWidget {
  BottomNavigationBarForApp({super.key, required this.indexNum});
  int indexNum = 0;

  void _logout(context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.logout,
                  color: Colors.green,
                  size: 35,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.green, fontSize: 23),
                ),
              ),
            ],
          ),
          content: const Text(
            "Do You want to Log Out ?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: indexNum,
      backgroundColor: Colors.greenAccent,
      height: 55,
      items: const <Widget>[
        Icon(
          Icons.list,
          size: 30,
          color: Colors.green,
        ),
        Icon(
          Icons.search,
          size: 30,
          color: Colors.green,
        ),
        Icon(
          Icons.add,
          size: 30,
          color: Colors.green,
        ),
        Icon(
          Icons.person_pin,
          size: 30,
          color: Colors.green,
        ),
        Icon(
          Icons.logout,
          size: 30,
          color: Colors.green,
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const JobsScreen()));
        } else if (index == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const SearchScreen()));
        } else if (index == 2) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const UploadJobsScreen()));
        } else if (index == 3) {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final String uid = user!.uid;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        userId: uid,
                      )));
        } else if (index == 4) {
          _logout(context);
        }
      },
    );
  }
}
