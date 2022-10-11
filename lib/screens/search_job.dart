import 'package:flutter/material.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({super.key});

  @override
  State<SearchJobScreen> createState() => _SearchJobScreenState();
}

class _SearchJobScreenState extends State<SearchJobScreen> {
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
          title: const Text("Search Jobs Screen"),
          centerTitle: true,
          // automaticallyImplyLeading: false,
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.search_outlined,
            //     color: Colors.white,
            //     size: 30,
            //   ),
            //   onPressed: () {
            //     Navigator.pushReplacement(context,
            //         MaterialPageRoute(builder: (c) => const SearchJobScreen()));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
