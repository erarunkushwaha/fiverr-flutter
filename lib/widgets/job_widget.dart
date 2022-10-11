// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/helpers/global_method.dart';
import 'package:fiverr/screens/job_details.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;
  const JobWidget({
    super.key,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog() {
    User? user = _auth.currentUser;
    final uid = user!.uid;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      if (widget.uploadedBy == uid) {
                        await FirebaseFirestore.instance
                            .collection('jobs')
                            .doc(widget.jobId)
                            .delete();

                        await Fluttertoast.showToast(
                            msg: "Job has been deleted",
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.grey,
                            fontSize: 18.0);
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      } else {
                        GlobalMethod.showErrorDialog(
                            error: "You cannot perform action on this job",
                            ctx: context);
                      }
                    } catch (e) {
                      GlobalMethod.showErrorDialog(
                          error: "This jobs cannot be deleted at this moment",
                          ctx: context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.delete, color: Colors.red),
                      Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black12,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => JobDetailScreen(
                      uploadedBy: widget.uploadedBy, jobId: widget.jobId)));
        },
        onLongPress: _deleteDialog,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 22),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.userImage,
                  fit: BoxFit.cover,
                )),
          ),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
