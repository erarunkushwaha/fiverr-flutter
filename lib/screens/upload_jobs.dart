import 'package:fiverr/helpers/persistent.dart';
import 'package:flutter/material.dart';
import 'package:fiverr/widgets/bottom_nav_bar.dart';

class UploadJobsScreen extends StatefulWidget {
  const UploadJobsScreen({super.key});

  @override
  State<UploadJobsScreen> createState() => _UploadJobsScreenState();
}

class _UploadJobsScreenState extends State<UploadJobsScreen> {
  final _uploadJobsFromKey = GlobalKey<FormState>();
  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Select Job Category");
  final TextEditingController _jobTitleController =
      TextEditingController(text: "");
  final TextEditingController _jobDescriptionController =
      TextEditingController(text: "");
  final TextEditingController _jobDeadlineController =
      TextEditingController(text: "");
  bool isLoading = false;

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

  _showTaskCategoryDialog() {
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _jobCategoryController.text ==
                            Persistent.jobCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
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
                          textTitle(label: "Jobs Title :"),
                          textformField(
                              valueKey: 'jobsTitle',
                              controller: _jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100),
                          textTitle(label: "Jobs Description :"),
                          textformField(
                              valueKey: 'jobsDescription',
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 300),
                          textTitle(label: "Jobs Deadline Date :"),
                          textformField(
                              valueKey: 'JobsDeadline',
                              controller: _jobDeadlineController,
                              enabled: true,
                              fct: () {},
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
                              onPressed: () {},
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
