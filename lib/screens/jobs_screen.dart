import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverr/helpers/persistent.dart';
import 'package:fiverr/screens/search_job.dart';
import 'package:fiverr/widgets/bottom_nav_bar.dart';
import 'package:fiverr/widgets/job_widget.dart';
import 'package:flutter/material.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String? jobCategoryFilter;

  void _selectCategory(index) {
    setState(() {
      jobCategoryFilter = Persistent.jobCategoryList[index];
    });
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }

  void showTaskCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              "Job Category",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _selectCategory(index),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.green,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                overflow: TextOverflow.fade),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel Filter",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
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
          title: const Text("Jobs Screen"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.filter_list_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: showTaskCategoryDialog,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => const SearchJobScreen()));
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .where("jobCategory", isEqualTo: jobCategoryFilter)
              .where("recruitment", isEqualTo: true)
              .orderBy("createdAt", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot shapshot) {
            if (shapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (shapshot.connectionState == ConnectionState.active) {
              if (shapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                  itemCount: shapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return JobWidget(
                      jobTitle: shapshot.data?.docs[index]['jobTitle'],
                      jobDescription: shapshot.data?.docs[index]
                          ['jobDescription'],
                      jobId: shapshot.data?.docs[index]['jobId'],
                      uploadedBy: shapshot.data?.docs[index]['uploadedBy'],
                      userImage: shapshot.data?.docs[index]['userImage'],
                      name: shapshot.data?.docs[index]['name'],
                      recruitment: shapshot.data?.docs[index]['recruitment'],
                      email: shapshot.data?.docs[index]['email'],
                      location: shapshot.data?.docs[index]['location'],
                    );
                  },
                );
              }
            } else {
              return const Center(child: Text("There is no jobs"));
            }
            return const Center(
              child: Text(
                "Soething Went Wrong",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
