import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String password;
  final List<int> watchlist; 
  const UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.watchlist
  });

  toJson(){
    return {
      "email":email,
      "password":password,
      "watchlist":watchlist
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>>document){
    final data=document.data()!;
    final watchlist = List<int>.from(data["watchlist"] ?? []);
    return UserModel(
        id: document.id,
        email: data["email"],
        password: data["password"],
        watchlist: watchlist
      );
  }
}