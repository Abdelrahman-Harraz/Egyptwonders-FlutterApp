// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// UserModel represents a user in the system
class UserModel {
  final String? id;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? nickName;
  final int? gender;
  final int? type; // changed in the firebase (0 for user, 1 for Admin)
  final DateTime? birthDate;
  final String? imageUrl; // Profile picture image
  final List<String>? likes; // favorites
  final String? nationality;

  // Constructor for creating a UserModel instance
  const UserModel(
      {this.fullName,
      this.nickName,
      this.phone,
      this.email,
      this.gender,
      this.type,
      this.birthDate,
      this.id,
      this.imageUrl,
      this.likes,
      this.nationality});

  // Method to create a copy of the UserModel with some fields updated
  UserModel copyWith(
      {String? fullName,
      String? nickName,
      String? phone,
      String? email,
      int? gender,
      int? type,
      DateTime? birthDate,
      String? id,
      String? imageUrl,
      List<String>? likes,
      String? nationality}) {
    return UserModel(
        fullName: fullName ?? this.fullName,
        nickName: nickName ?? this.nickName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        type: type ?? this.type,
        birthDate: birthDate ?? this.birthDate,
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        likes: likes ?? likes,
        nationality: nationality ?? this.nationality);
  }

  // Factory method to create a UserModel instance from a Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      fullName: data['fullName'],
      phone: data['phone'],
      nickName: data['nickName'],
      email: data['email'],
      gender: data['gender'],
      nationality: data['nationality'],
      type: data['type'],
      birthDate: data['birthDate'] != null
          ? (data['birthDate'] as Timestamp).toDate()
          : null,
      id: doc.id,
      imageUrl: data['imageUrl'],
      likes: data['likes'] != null ? List<String>.from(data['likes']) : [],
    );
  }

  // Method to convert the UserModel instance to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'nickName': nickName,
      'phone': phone,
      'email': email,
      'gender': gender,
      'type': type,
      'birthDate': birthDate,
      'id': id,
      'imageUrl': imageUrl,
      'likes': likes,
      'nationality': nationality
    };
  }

  // Override the toString method for better debugging output
  @override
  String toString() {
    return 'UserModel(fullName: $fullName, phone: $phone, email: $email, nickName: $nickName, gender: $gender, type: $type, birthDate: $birthDate, id: $id, imageUrl: $imageUrl ,likes: $likes, nationality: $nationality))';
  }
}
