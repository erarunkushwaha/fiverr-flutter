import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverr/screens/jobs_screen.dart';
import 'package:fiverr/widgets/job_widget.dart';
import 'package:flutter/material.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({super.key});

  @override
  State<SearchJobScreen> createState() => _SearchJobScreenState();
}

class _SearchJobScreenState extends State<SearchJobScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search Query";

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: "Serach for jobs....",
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchquery(query),
    );
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

  void _clearSearchquery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchquery("");
    });
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
        // bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const JobsScreen()));
            },
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .where("jobTitle", isGreaterThanOrEqualTo: searchQuery)
              .where("recruitment", isEqualTo: true)
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
                      return JobWidget(
                        jobTitle: snapshot.data?.docs[index]['jobTitle'],
                        jobDescription: snapshot.data?.docs[index]
                            ['jobDescription'],
                        jobId: snapshot.data?.docs[index]['jobId'],
                        uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                        userImage: snapshot.data?.docs[index]['userImage'],
                        name: snapshot.data?.docs[index]['name'],
                        recruitment: snapshot.data?.docs[index]['recruitment'],
                        email: snapshot.data?.docs[index]['email'],
                        location: snapshot.data?.docs[index]['location'],
                      );
                    });
              }
            } else {
              return const Center(child: Text("There is no jobs"));
            }
            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}
