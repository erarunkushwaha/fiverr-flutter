import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiverr/helpers/global_variables.dart';

class Persistent {
  void getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    name = userDoc.get("name");
    print("name $name");
    userImage = userDoc.get("userImage");
    print("userImage $userImage");

    location = userDoc.get("address");
    print("location $location");
  }

  static List<String> jobCategoryList = [
    'Construction',
    'Education and Tranning',
    'Human Resources',
    'Public Relations',
    'International Business',
    'Sales',
    'Market Research',
    'Marketing',
    'Customer Service',
    'Hospitality',
    'Maintenance',
    'Manufacturing',
    'Information Technology (IT)',
    'Healthcare/Medical',
    'Graphic Designer',
    'Marketing Communications',
    'Content Marketing ',
    'Copywriter',
    'Digital Marketing Manager',
    'Administrative Assistant',
    'Business Analyst',
    'Office Assistant',
    'Secretary',
    'Receptionist',
    'Program Manager',
    'Administrative Analyst',
    'Data Entry'
  ];
}
