import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverr/widgets/all_companies_widget.dart';
import 'package:fiverr/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search Query";
  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: "Serach for companies....",
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchquery(query),
    );
  }

  void _clearSearchquery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchquery("");
    });
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
          onPressed: () {
            _clearSearchquery();
          },
          icon: const Icon(Icons.clear))
    ];
  }

  void updateSearchquery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green[200]!,
                  Colors.greenAccent[400]!,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("name", isGreaterThanOrEqualTo: searchQuery)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AllWorkersWidget(
                        userId: snapshot.data?.docs[index]['id'],
                        userName: snapshot.data?.docs[index]['name'],
                        userEmail: snapshot.data?.docs[index]['email'],
                        phoneNumber: snapshot.data?.docs[index]['phoneNo'],
                        userImageUrl: snapshot.data?.docs[index]['userImage'],
                      );
                    });
              }
            } else {
              return const Center(child: Text("There is no Users"));
            }
            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}
