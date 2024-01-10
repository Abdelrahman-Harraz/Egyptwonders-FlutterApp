import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egypt_wonders/features/places/repo/likes_repository.dart';

// Model class representing information of a place
class PlaceModel {
  String? id;
  String? detailsId;
  bool? isVenue;
  bool? isEventsAndActivities;
  bool? isScan;
  String? type;
  String? coverImageUrl;
  String? name;
  DateTime? startDay;
  DateTime? endDay;
  DateTime? startHour;
  DateTime? endHour;
  bool? isLiked;
  String? buildingNumber;
  String? streetName;
  String? city;
  String? governorate;
  String? country;
  final double? price;
  String? dayOffName;
  String? endDayName;

  // Constructor for initializing the PlaceModel
  PlaceModel({
    this.price,
    this.id,
    this.detailsId,
    this.isEventsAndActivities,
    this.isVenue,
    this.isScan,
    this.type,
    this.name,
    this.startDay,
    this.endDay,
    this.startHour,
    this.endHour,
    this.isLiked,
    this.buildingNumber,
    this.streetName,
    this.city,
    this.governorate,
    this.country,
    this.coverImageUrl,
    this.dayOffName,
    this.endDayName,
  });

  // CopyWith method to create a new instance with updated values
  PlaceModel copyWith({
    double? price,
    String? id,
    String? detailsId,
    String? coverImageUrl,
    bool? isVenue,
    bool? isEventsAndActivities,
    bool? isScan,
    String? type,
    String? name,
    DateTime? startDay,
    DateTime? endDay,
    DateTime? endHour,
    DateTime? startHour,
    bool? isLiked,
    String? buildingNumber,
    String? streetName,
    String? city,
    String? governorate,
    String? country,
    String? startDayName,
    String? endDayName,
  }) {
    return PlaceModel(
        price: price ?? this.price,
        id: id ?? this.id,
        detailsId: detailsId ?? this.detailsId,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl,
        isVenue: isVenue ?? this.isVenue,
        isEventsAndActivities:
            isEventsAndActivities ?? this.isEventsAndActivities,
        isScan: isScan ?? this.isScan,
        type: type ?? this.type,
        name: name ?? this.name,
        startDay: startDay ?? this.startDay,
        endDay: endDay ?? this.endDay,
        startHour: startHour ?? this.startHour,
        endHour: endHour ?? this.endHour,
        isLiked: isLiked ?? this.isLiked,
        buildingNumber: buildingNumber ?? this.buildingNumber,
        streetName: streetName ?? this.streetName,
        city: city ?? this.city,
        governorate: governorate ?? this.governorate,
        country: country ?? this.country,
        dayOffName: startDayName ?? this.dayOffName,
        endDayName: endDayName ?? this.endDayName);
  }

  // Factory method to create an instance from Firestore data
  factory PlaceModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return PlaceModel(
      price: data['price'],
      id: data['id'],
      detailsId: data['detailsId'],
      coverImageUrl: data['coverImageUrl'],
      isEventsAndActivities: data['isFeatured'],
      isVenue: data['isPopular'],
      isScan: data['isScan'],
      type: data['type'],
      name: data['name'],
      startDay: data['day'] != null ? data['day'].toDate() : DateTime.now(),
      endDay: data['day'] != null ? data['day'].toDate() : DateTime.now(),
      endHour:
          data['endHour'] != null ? data['endHour'].toDate() : DateTime.now(),
      startHour: data['startHour'] != null
          ? data['startHour'].toDate()
          : DateTime.now(),
      isLiked: LikesList.likes.isNotEmpty
          ? LikesList.likes.contains(data['id'])
          : false,
      buildingNumber: data['buildingNumber'],
      streetName: data['streetName'],
      city: data['city'],
      governorate: data['governorate'],
      country: data['country'],
      dayOffName: data['startDayName'],
      endDayName: data['endDayName'],
    );
  }

  // Method to convert the object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'id': id,
      'detailsId': detailsId,
      'coverImageUrl': coverImageUrl,
      'isPopular': isVenue,
      'isFeatured': isEventsAndActivities,
      'isScan': isScan,
      'type': type,
      'name': name,
      'startDay': startDay,
      'endDay': endDay,
      'endHour': endHour,
      'startHour': startHour,
      'buildingNumber': buildingNumber,
      'streetName': streetName,
      'city': city,
      'governorate': governorate,
      'country': country,
      'startDayName': dayOffName,
      'endDayName': endDayName,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'PlaceModel(id: $id, detailsId: $detailsId, isPopular: $isVenue, endDay: $endDay, isFeatured: $isEventsAndActivities, isScan: $isScan, type: $type, coverImageUrl: $coverImageUrl, name: $name, startDay: $startDay, startHour: $startHour, endHour: $endHour, isLiked: $isLiked, buildingNumber: $buildingNumber, streetName: $streetName, city: $city, governorate: $governorate, country: $country, price: $price, startDayName: $dayOffName, endDayName: $endDayName)';
  }
}
