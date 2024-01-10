// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionModel {
  // Unique identifier for the collection
  String? id;

  // User identifier associated with the collection
  String? userId;

  // Name of the collection
  String? name;

  // Date and time when the collection was added
  DateTime? dateAdded;

  // File path for the background image of the collection
  String? backgroundImagePath;

  // Constructor to initialize a CollectionModel instance
  CollectionModel({
    this.id,
    this.userId,
    this.name,
    this.dateAdded,
    this.backgroundImagePath,
  });

  // Method to create a copy of the CollectionModel with optional modifications
  CollectionModel copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? dateAdded,
    String? backgroundImagePath,
  }) {
    return CollectionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dateAdded: dateAdded ?? this.dateAdded,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
    );
  }

  // Method to convert the CollectionModel to a map for storage in Firestore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'dateAdded': dateAdded?.millisecondsSinceEpoch,
      'backgroundImagePath': backgroundImagePath,
    };
  }

  // Factory method to create a CollectionModel instance from Firestore document data
  factory CollectionModel.fromFirestore(DocumentSnapshot doc) {
    Map map = doc.data() as Map<String, dynamic>;
    return CollectionModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      backgroundImagePath: map['backgroundImagePath'] != null
          ? map['backgroundImagePath'] as String
          : null,
      dateAdded: map['dateAdded'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateAdded'] as int)
          : null, // Convert milliseconds back to DateTime
    );
  }

  // Factory method to create a CollectionModel instance from a map
  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      dateAdded: map['dateAdded'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateAdded'] as int)
          : null,
      backgroundImagePath: map['backgroundImagePath'] != null
          ? map['backgroundImagePath'] as String
          : null,
    );
  }

  // Method to convert the CollectionModel to a JSON-encoded string
  String toJson() => json.encode(toMap());

  // Factory method to create a CollectionModel instance from a JSON string
  factory CollectionModel.fromJson(String source) =>
      CollectionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Override toString for a human-readable representation of the CollectionModel
  @override
  String toString() =>
      'CollectionModel(id: $id, userId: $userId, name: $name, dateAdded: $dateAdded, backgroundImagePath: $backgroundImagePath)';

  // Override equality operator to compare CollectionModel instances
  @override
  bool operator ==(covariant CollectionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.name == name &&
        other.dateAdded == dateAdded;
  }

  // Override hashCode for consistent hashing of CollectionModel instances
  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ name.hashCode ^ dateAdded.hashCode;
}
