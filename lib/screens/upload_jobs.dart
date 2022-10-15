import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/helpers/global_method.dart';
import 'package:fiverr/helpers/global_variables.dart';
import 'package:fiverr/helpers/persistent.dart';
import 'package:flutter/material.dart';
import 'package:fiverr/widgets/bottom_nav_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class UploadJobsScreen extends StatefulWidget {
  const UploadJobsScreen({super.key});

  @override
  State<UploadJobsScreen> createState() => _UploadJobsScreenState();
}

class _UploadJobsScreenState extends State<UploadJobsScreen> {
  final _uploadJobsFromKey = GlobalKey<FormState>();
  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Choose Category");
  final TextEditingController _jobTitleController =
      TextEditingController(text: "");
  final TextEditingController _jobDescriptionController =
      TextEditingController(text: "");
  final TextEditingController _jobDeadlineController =
      TextEditingController(text: "Job Deadline Date");
  bool isLoading = false;
  DateTime? picked;
  Timestamp? jobsDeadlineTimeStamp;
  Uuid? uuid = const Uuid();

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _jobDeadlineController.dispose();
  }

  Widget textformField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "value is missing";
            } else {
              return null;
            }
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(color: Colors.white),
          maxLines: valueKey == "jobsDescription" ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black45,
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget textTitle({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  void _selectCategory(index) {
    setState(() {
      _jobCategoryController.text = Persistent.jobCategoryList[index];
    });
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }

  void _showTaskCategoryDialog() {
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.60,
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
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        });
  }

  _pickedDateDialog() async {
    picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 0)),
        lastDate: DateTime(2200));

    if (picked != null) {
      setState(() {
        _jobDeadlineController.text =
            '${picked!.year} - ${picked!.month} - ${picked!.day} ';
        jobsDeadlineTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            picked!.microsecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final jobId = uuid!.v4();

    User? user = FirebaseAuth.instance.currentUser;

    final uid = user!.uid;

    final isValid = _uploadJobsFromKey.currentState!.validate();

    if (isValid) {
      if (_jobDeadlineController.text == "Choose job Deadline date" ||
          _jobDeadlineController.text == "Choose job category") {
        GlobalMethod.showErrorDialog(
            error: "Please Pick Everything", ctx: context);
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection("jobs").doc(jobId).set({
          "jobId": jobId,
          "uploadedBy": uid,
          'email': user.email,
          'jobTitle': _jobTitleController.text,
          'jobDescription': _jobDescriptionController.text,
          'deadLineDate': _jobDeadlineController.text,
          'deadlineDateTimeStamp': jobsDeadlineTimeStamp,
          'jobCategory': _jobCategoryController.text,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });

        await Fluttertoast.showToast(
          msg: "The tasks has been uploaded",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = "Select Job Category";
          _jobDeadlineController.text = "Job Deadline Date";
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: e.toString(), ctx: context);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getMyData();
  // }

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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            color: Colors.white10,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Please fill all  field",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Signatra"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _uploadJobsFromKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textTitle(label: "Jobs Category :"),
                          textformField(
                              valueKey: 'jobsCategory',
                              controller: _jobCategoryController,
                              enabled: false,
                              fct: () {
                                _showTaskCategoryDialog();
                              },
                              maxLength: 100),
                          textTitle(label: "Job Title :"),
                          textformField(
                              valueKey: 'jobsTitle',
                              controller: _jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100),
                          textTitle(label: "Job Description :"),
                          textformField(
                              valueKey: 'jobsDescription',
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 300),
                          textTitle(label: "Jobs Deadline Date :"),
                          textformField(
                              valueKey: 'JobDeadline',
                              controller: _jobDeadlineController,
                              enabled: false,
                              fct: () {
                                _pickedDateDialog();
                              },
                              maxLength: 100),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : MaterialButton(
                              onPressed: () {
                                _uploadTask();
                              },
                              color: Colors.black54,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Post  Now",
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 25,
                                        fontFamily: "Signatra",
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.upload_file,
                                      color: Colors.greenAccent,
                                    ),
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
        )),
      ),
    );
  }
}
