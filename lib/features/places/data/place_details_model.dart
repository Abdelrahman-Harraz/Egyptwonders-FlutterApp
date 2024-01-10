// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

// Model class representing details of a place
class PlaceDetailsModel {
  final String? id;
  final String? url;
  final List<String>? imageslist;
  final String? placeId;
  final double? lowPrice;
  final double? highPrice;
  final String? currency;
  final List<String>? gallerylist;
  final String? about;

  // Constructor for initializing the PlaceDetailsModel
  const PlaceDetailsModel({
    this.id,
    this.placeId,
    this.imageslist,
    this.lowPrice,
    this.highPrice,
    this.currency,
    this.gallerylist,
    this.about,
    this.url,
  });

  // CopyWith method to create a new instance with updated values
  PlaceDetailsModel copyWith({
    String? id,
    String? placeId,
    String? url,
    List<String>? imageslist,
    double? lowPrice,
    double? highPrice,
    String? currency,
    List<String>? gallerylist,
    String? about,
  }) {
    return PlaceDetailsModel(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      url: url ?? this.url,
      imageslist: imageslist ?? this.imageslist,
      lowPrice: lowPrice ?? this.lowPrice,
      highPrice: highPrice ?? this.highPrice,
      currency: currency ?? this.currency,
      gallerylist: gallerylist ?? this.gallerylist,
      about: about ?? this.about,
    );
  }

  // Factory method to create an instance from Firestore data
  factory PlaceDetailsModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return PlaceDetailsModel(
      id: data['id'],
      placeId: data['placeId'],
      url: data['url'],
      imageslist: List<String>.from(data['imageslist']),
      lowPrice: data['lowPrice'],
      highPrice: data['highPrice'],
      currency: data['currency'],
      gallerylist: List<String>.from(data['gallerylist']),
      about: data['about'],
    );
  }

  // Method to convert the object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placeId': placeId,
      'url': url,
      'imageslist': imageslist,
      'lowPrice': lowPrice,
      'highPrice': highPrice,
      'currency': currency,
      'gallerylist': gallerylist,
      'about': about,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'PlaceDetailsModel(id: $id, url: $url, imageslist: $imageslist, placeId: $placeId, lowPrice: $lowPrice, highPrice: $highPrice, currency: $currency, gallerylist: $gallerylist, about: $about)';
  }
}
