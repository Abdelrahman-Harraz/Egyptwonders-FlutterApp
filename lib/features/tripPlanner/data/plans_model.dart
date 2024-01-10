// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// PlanModel represents a plan for visiting a place.
class PlanModel {
  String? id;
  String? userId;
  String? placeId;
  String? collectionId;
  String? city;
  String? placeName;
  DateTime? day;
  DateTime? time;
  bool? checkedIn;
  String? placeCoverImage;

  // PlanModel constructor with optional parameters for flexibility.
  PlanModel({
    this.id,
    this.userId,
    this.placeId,
    this.collectionId,
    this.city,
    this.placeName,
    this.day,
    this.time,
    this.checkedIn,
    this.placeCoverImage,
  });

  // CopyWith method for creating a new instance with updated values.
  PlanModel copyWith({
    String? id,
    String? userId,
    String? placeId,
    String? collectionId,
    String? country,
    String? placeName,
    DateTime? day,
    DateTime? time,
    bool? checkedIn,
    String? placeCoverImage,
  }) {
    return PlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      placeId: placeId ?? this.placeId,
      collectionId: collectionId ?? this.collectionId,
      city: country ?? this.city,
      placeName: placeName ?? this.placeName,
      day: day ?? this.day,
      time: time ?? this.time,
      checkedIn: checkedIn ?? this.checkedIn,
      placeCoverImage: placeCoverImage ?? this.placeCoverImage,
    );
  }

  // Convert the PlanModel instance to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'placeId': placeId,
      'collectionId': collectionId,
      'country': city,
      'placeName': placeName,
      'day': day?.millisecondsSinceEpoch,
      'time': time?.millisecondsSinceEpoch,
      'checkedIn': checkedIn,
      'placeCoverImage': placeCoverImage,
    };
  }

  // Factory method to create a PlanModel instance from Firestore data.
  factory PlanModel.fromFirestore(DocumentSnapshot doc) {
    Map map = doc.data() as Map<String, dynamic>;
    return PlanModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      placeId: map['placeId'] != null ? map['placeId'] as String : null,
      collectionId:
          map['collectionId'] != null ? map['collectionId'] as String : null,
      city: map['country'] != null ? map['country'] as String : null,
      placeName: map['placeName'] != null ? map['placeName'] as String : null,
      day: map['day'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['day'] as int)
          : null,
      time: map['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['time'] as int)
          : null,
      checkedIn: map['checkedIn'] != null ? map['checkedIn'] as bool : null,
      placeCoverImage: map['placeCoverImage'] != null
          ? map['placeCoverImage'] as String
          : null,
    );
  }

  // Convert the PlanModel instance to a JSON string.
  String toJson() => json.encode(toMap());

  // toString method for a readable representation of the PlanModel instance.
  @override
  String toString() {
    return 'PlanModel(id: $id, userId: $userId, placeId: $placeId, country: $city, placeName: $placeName, day: $day, time: $time, checkedIn: $checkedIn, placeCoverImage: $placeCoverImage,collectionId: $collectionId)';
  }

  // Equality check for two PlanModel instances.
  @override
  bool operator ==(covariant PlanModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.placeId == placeId &&
        other.city == city &&
        other.placeName == placeName &&
        other.day == day &&
        other.time == time &&
        other.checkedIn == checkedIn &&
        other.placeCoverImage == placeCoverImage;
  }

  // Hash code calculation for the PlanModel instance.
  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        placeId.hashCode ^
        city.hashCode ^
        placeName.hashCode ^
        day.hashCode ^
        time.hashCode ^
        checkedIn.hashCode ^
        placeCoverImage.hashCode;
  }

  // Factory method to create a PlanModel instance from a Map.
  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'] as String,
      userId: map['userId'] != null ? map['userId'] as String : null,
      placeId: map['placeId'] != null ? map['placeId'] as String : null,
      collectionId:
          map['collectionId'] != null ? map['collectionId'] as String : null,
      city: map['country'] != null ? map['country'] as String : null,
      placeName: map['placeName'] != null ? map['placeName'] as String : null,
      day: map['day'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['day'] as int)
          : null,
      time: map['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['time'] as int)
          : null,
      checkedIn: map['checkedIn'] != null ? map['checkedIn'] as bool : null,
      placeCoverImage: map['placeCoverImage'] != null
          ? map['placeCoverImage'] as String
          : null,
    );
  }

  // Factory method to create a PlanModel instance from a JSON string.
  factory PlanModel.fromJson(String source) =>
      PlanModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
