import 'package:demo_app/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController {
  static UserRepository get instance =>Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async{

    await _db.collection("Users").add(user.toJson()).whenComplete(() 
      => Get.snackbar("success", "account created",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.withOpacity(0.1),
                      colorText: Colors.green),
    )
    .catchError((error,StackTrace){
      Get.snackbar("error", "something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red

          );
          print(error.toString());

    });
  }


  Future<UserModel> getUserDetails(String email) async {
    final snapshot= await _db.collection("Users").where("email",isEqualTo: email).get();
    final userData= snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }


  
  Future<void> appendStringToWatchlist(String userEmail, int newValue) async {
  try {
    final userCollection = _db.collection("Users");
    
    // Query for the user document with the provided email
    final userQuerySnapshot = await userCollection.where("email", isEqualTo: userEmail).get();
    if (userQuerySnapshot.docs.isNotEmpty) {
      // Assuming there's only one user document with the provided email
      final userDoc = userQuerySnapshot.docs.first.reference;
      
      // Get the current user document data
      final userData = userQuerySnapshot.docs.first.data() as Map<String, dynamic>;
      
      // Retrieve the current watchlist from the user data
      final List<int> currentWatchlist = List<int>.from(userData["watchlist"] ?? []);

      // Append the new value to the watchlist
      currentWatchlist.add(newValue);

      // Update the user document with the modified watchlist
      await userDoc.update({"watchlist": currentWatchlist});
    } else {
      throw Exception("User document not found for email: $userEmail");
    }
  } catch (error) {
    print("Error appending string to watchlist: $error");
    throw error;
  }
  }

}