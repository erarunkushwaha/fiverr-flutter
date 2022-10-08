import 'package:flutter/material.dart';
import 'package:fiverr/widgets/bottom_nav_bar.dart';

class UploadJobsScreen extends StatefulWidget {
  const UploadJobsScreen({super.key});

  @override
  State<UploadJobsScreen> createState() => _UploadJobsScreenState();
}

class _UploadJobsScreenState extends State<UploadJobsScreen> {
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
          title: const Text("Upload Jobs Now"),
          centerTitle: true,
        ),
      ),
    );
  }
}
