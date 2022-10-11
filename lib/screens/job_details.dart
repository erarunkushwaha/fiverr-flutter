// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiverr/screens/jobs_screen.dart';
import 'package:flutter/material.dart';

class JobDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobId;
  const JobDetailScreen({
    super.key,
    required this.uploadedBy,
    required this.jobId,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimestamp;
  Timestamp? deadlineDateTimestamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCampany;
  String? emailCompany;
  int? applicants = 0;
  bool isDeadLineAvialable = false;

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get("name");
        userImageUrl = userDoc.get("userImage");
      });
    }
    final DocumentSnapshot jobDoc = await FirebaseFirestore.instance
        .collection("jobs")
        .doc(widget.jobId)
        .get();

    if (jobDoc == null) {
      return;
    } else {
      setState(() {
        jobTitle = jobDoc.get("jobTitle");
        jobDescription = jobDoc.get("jobDescription");
        recruitment = jobDoc.get("recruitment");
        emailCompany = jobDoc.get("email");
        locationCampany = jobDoc.get("location");
        applicants = jobDoc.get("applicants");
        postedDateTimestamp = jobDoc.get("createdAt");
        deadlineDateTimestamp = jobDoc.get("deadlineDateTimeStamp");
        deadlineDate = jobDoc.get("deadLineDate");
        var postDate = postedDateTimestamp!.toDate();
        postedDate = "${postDate.year} -  ${postDate.month} - ${postDate.day}";
      });
      // var date = deadlineDateTimestamp!.toDate();
      // isDeadLineAvialable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState() {
    super.initState();
    getJobData();
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
          title: const Text("Search Jobs Screen"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const JobsScreen()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            jobTitle ?? "",
                            maxLines: 3,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl ??
                                        "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_960_720.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    locationCampany ?? "",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
