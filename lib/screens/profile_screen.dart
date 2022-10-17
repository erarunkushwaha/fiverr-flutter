import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/screens/user_state.dart';
import 'package:fiverr/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  Widget contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: () {
            fct();
          },
        ),
      ),
    );
  }

  void openWhatsAppChat() async {
    var url = "https://wa.me/$phoneNumber?text=HelloWorld";
    launchUrlString(url);
  }

  void mailTo() async {
    final Uri params = Uri(
        scheme: "mailto",
        path: email,
        query:
            "subject=Write subject here, Please&body=Hello, Please write your details here");
    final url = params.toString();
    launchUrlString(url);
  }

  void cellPhoneNumber() async {
    var url = "tel://$phoneNumber";
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[100]!,
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
                                  height: 60,
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
                                const SizedBox(height: 20),
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
                                      icon: Icons.phone, content: phoneNumber),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(
                                  thickness: 1,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                isSameUser
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          contactBy(
                                            color: Colors.green,
                                            fct: () {
                                              openWhatsAppChat();
                                            },
                                            icon: Icons.whatsapp,
                                          ),
                                          contactBy(
                                            color: Colors.red,
                                            fct: () {
                                              mailTo();
                                            },
                                            icon: Icons.email_outlined,
                                          ),
                                          contactBy(
                                            color: Colors.purple,
                                            fct: () {
                                              cellPhoneNumber();
                                            },
                                            icon: Icons.call,
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 20),
                                !isSameUser
                                    ? Container()
                                    : Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          child: MaterialButton(
                                            onPressed: () {
                                              auth.signOut();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const UserState()));
                                            },
                                            color: Colors.green.shade300,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    "LOGOUT",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Signatra",
                                                      fontSize: 24,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    Icons.logout,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.22,
                              height: size.width * 0.22,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Colors.green.shade300,
                                ),
                                image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover),
                              ),
                            )
                          ],
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
