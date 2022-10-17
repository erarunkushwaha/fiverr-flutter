import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? name;
  String email = "";
  String phoneNumber = "";
  String imageUrl = "";
  String joinedAt = "";
  bool isloading = false;
  bool isSameUser = false;

  void getUserData() async {
    try {
      isloading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get();

      // ignore: unnecessary_null_comparison
      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get("name");
          email = userDoc.get("email");
          phoneNumber = userDoc.get("phoneNo");
          imageUrl = userDoc.get("userImage");
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt =
              "${joinedDate.year} - ${joinedDate.month} - ${joinedDate.day}  ";
          name = userDoc.get("name");
        });
        User? user = auth.currentUser;
        final uid = user!.uid;
        setState(() {
          isSameUser = uid == widget.userId;
        });
      }
    } catch (e) {
      //
    } finally {
      isloading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[200]!,
            Colors.greenAccent[200]!,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3),
        body: Center(
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Stack(
                      children: [
                        Card(
                          color: Colors.white10,
                          margin: const EdgeInsets.all(38),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    name ?? "Name here",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 30),
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Account  Infromation",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: userInfo(
                                        icon: Icons.email, content: email)),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: userInfo(
                                      icon: Icons.email, content: email),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: userInfo(
                                      icon: Icons.phone, content: phoneNumber),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
